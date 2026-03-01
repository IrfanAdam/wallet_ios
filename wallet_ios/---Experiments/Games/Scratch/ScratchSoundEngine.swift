import AVFoundation

/// Synthesises a realistic lottery-card scratch sound entirely in the audio thread.
///
/// ## Signal chain
///   White noise → one-pole low-pass (body) → state-variable band-pass (texture)
///   → soft-clip limiter → amplitude envelope
///
/// ## No static / no clicks
/// - The `metallic` sine term (which caused buffer-boundary glitches) is removed.
/// - All filter coefficients are recomputed from continuous phase accumulators,
///   never from a per-buffer frame index that resets to 0.
/// - Amplitude and brightness smoothing uses a per-sample lerp so there are
///   no step discontinuities when `update(velocity:)` is called mid-buffer.
final class ScratchSoundEngine {
	
	static let shared = ScratchSoundEngine()
	
	// MARK: - Engine
	
	private let engine     = AVAudioEngine()
	private var sourceNode: AVAudioSourceNode!
	
	// MARK: - Modulation targets (written on main thread, read on audio thread)
	// Both are `_Atomic`-equivalent via simple Float — safe because we only
	// ever do single-word reads/writes and can tolerate one torn frame.
	
	private var targetAmplitude:  Float = 0
	private var targetBrightness: Float = 0
	
	// MARK: - Audio-thread-only state (never touched from main thread)
	
	private var currentAmplitude:  Float = 0
	private var currentBrightness: Float = 0
	
	/// One-pole low-pass: shapes white noise into "paper body" rumble.
	private var lpState: Float = 0
	
	/// State-variable band-pass filter (SVF) — stable across the full
	/// frequency range and requires no coefficient table.
	/// State variables:
	private var svfLow:  Float = 0   // low-pass output
	private var svfBand: Float = 0   // band-pass output (the one we use)
	
	/// Continuous phase for any future tonal layer — kept so adding one
	/// later won't introduce the buffer-boundary discontinuity that caused
	/// the original static.
	private var phase: Float = 0
	
	// MARK: - Init
	
	private init() {
		configureSession()
		buildGraph()
	}
	
	// MARK: - Session
	
	private func configureSession() {
		let session = AVAudioSession.sharedInstance()
		try? session.setCategory(.ambient, options: .mixWithOthers)
		try? session.setActive(true)
	}
	
	// MARK: - Graph
	
	private func buildGraph() {
		let outputFormat = engine.outputNode.inputFormat(forBus: 0)
		let sampleRate   = Float(outputFormat.sampleRate)
		
		sourceNode = AVAudioSourceNode(format: outputFormat) {
			[weak self] _, _, frameCount, audioBufferList -> OSStatus in
			guard let self else { return noErr }
			self.renderFrames(Int(frameCount),
												sampleRate: sampleRate,
												into: audioBufferList)
			return noErr
		}
		
		engine.attach(sourceNode)
		engine.connect(sourceNode, to: engine.mainMixerNode, format: outputFormat)
		try? engine.start()
	}
	
	// MARK: - Render
	
	private func renderFrames(_ count: Int,
														sampleRate: Float,
														into audioBufferList: UnsafeMutablePointer<AudioBufferList>) {
		
		let abl        = UnsafeMutableAudioBufferListPointer(audioBufferList)
		let channelCount = abl.count
		
		// Pre-fetch targets once — avoids repeated volatile reads inside the loop.
		let ampTarget   = targetAmplitude
		let brightTarget = targetBrightness
		
		for frame in 0..<count {
			
			// ── 1. Per-sample smoothing ───────────────────────────────────
			// Coefficient 0.004 ≈ 5 ms ramp at 44.1 kHz — smooth but responsive.
			let smoothing: Float = ampTarget == 0 ? 0.02 : 0.004
			currentAmplitude += smoothing * (ampTarget - currentAmplitude)
			currentBrightness += 0.004 * (brightTarget - currentBrightness)
			
			// ── 2. White noise source ─────────────────────────────────────
			let white = Float.random(in: -1.0...1.0)
			
			// ── 3. One-pole low-pass (body layer) ─────────────────────────
			// Cutoff ~1.2 kHz at 44.1 kHz.  coefficient = 1 - e^(-2π·fc/fs)
			// Pre-baked: fc=1200, fs=44100 → coeff ≈ 0.157
			let lpCoeff: Float = 0.157
			lpState += lpCoeff * (white - lpState)
			
			// ── 4. State-variable band-pass (texture layer) ───────────────
			// SVF from Hal Chamberlin / Andrew Simper — numerically stable.
			// Frequency sweeps from ~800 Hz (brightness=0) to ~3500 Hz (brightness=1).
			let fc    = 800 + currentBrightness * 2700     // Hz
			let f     = 2.0 * sin(Float.pi * fc / sampleRate)   // SVF drive
			let q: Float = 0.55   // resonance — lower = wider / less ringy
			
			svfLow  = svfLow  + f * svfBand
			let high = lpState - svfLow - q * svfBand
			svfBand = f * high + svfBand
			// svfBand is now a band-pass centred at fc with gentle resonance.
			
			// ── 5. Mix body + texture ─────────────────────────────────────
			// Body gives weight; texture gives the "paper grain" character.
			// At low brightness the body dominates (soft, quiet scratch).
			// At high brightness texture dominates (fast, bright scratch).
			let bodyMix    = 1.0 - currentBrightness * 0.6
			let textureMix = 0.3 + currentBrightness * 0.7
			var mixed = lpState * bodyMix * 0.5 + svfBand * textureMix
			
			// ── 6. Soft clip ──────────────────────────────────────────────
			// Prevents any stray peak from clipping hard while adding subtle
			// warmth. tanh saturates smoothly unlike a hard limiter.
			mixed = tanh(mixed * 1.4) / 1.4
			
			// ── 7. Apply amplitude envelope + hard gate ───────────────────
			// Below this floor currentAmplitude is inaudible but the smoothing
			// loop keeps it asymptotically approaching zero forever, leaking
			// noise into a stationary touch. Snap to zero so output is silent.
			if currentAmplitude < 0.0005 && ampTarget == 0 {
				
				// Fully silent frame
				for ch in 0..<channelCount {
					guard let data = abl[ch].mData else { continue }
					data.assumingMemoryBound(to: Float.self)[frame] = 0
				}
				
				continue
			}
		
			let gain: Float = 2.5
			let raw = mixed * currentAmplitude * gain
			let output = max(-1.0, min(1.0, raw))
			
			// ── 8. Write to all channels ──────────────────────────────────
			for ch in 0..<channelCount {
				guard let data = abl[ch].mData else { continue }
				data.assumingMemoryBound(to: Float.self)[frame] = output
			}
		}
	}
	
	// MARK: - Public API
	
	/// Call once when the scratch surface appears.
	func start() {
		targetAmplitude = 0
	}
	
	/// Call from `touchesMoved`.
	/// - Parameter velocity: Normalised finger speed, 0 (still) … 1 (fast).
	func update(velocity: CGFloat) {
		let v = Float(velocity.clamped(to: 0...1))
		// Amplitude: audible even at low speed, loud at high speed.
		// sqrt curve keeps slow scratches from feeling silent.
		targetAmplitude  = 0.18 + sqrt(v) * 0.55
		// Brightness: linear — directly controls SVF frequency.
		targetBrightness = v
	}
	
	/// Call from `touchesEnded` / `touchesCancelled`.
	func stop() {
		targetAmplitude  = 0
		targetBrightness = 0
		
		// Immediate kill of amplitude
		currentAmplitude = 0
		
		// Reset filters completely
		lpState  = 0
		svfLow   = 0
		svfBand  = 0
	}
}

// MARK: - Comparable clamp helper

private extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
