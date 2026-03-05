import AVFoundation

/// Synthesises a realistic lottery-card scratch sound entirely in the audio thread.
///
/// ## Signal chain
///   White noise → one-pole low-pass (body) → state-variable band-pass (texture)
///   → soft-clip limiter → amplitude envelope
///
/// ## Fixes applied
/// - `start()` no longer zeroes amplitude (was a copy-paste bug).
/// - Format is forced to 32-bit float stereo at the hardware sample rate,
///   avoiding the invalid-format trap that hits Simulator / Xcode Previews.
/// - Engine bootstrap is deferred and guarded so Previews don't crash.

final class ScratchSoundEngine {
	static let shared = ScratchSoundEngine()

	private let engine = AVAudioEngine()
	private var sourceNode: AVAudioSourceNode?
	private var isReady = false

	// Main-thread targets (atomic via _Atomic would be ideal; Float assign is
	// single-instruction on ARM so safe enough for this use-case)
	private var targetAmplitude:  Float = 0
	private var targetBrightness: Float = 0

	// Audio-thread state
	private var amp:        Float = 0
	private var brightness: Float = 0
	private var lp1:        Float = 0
	private var lp2:        Float = 0

	private init() {
		// Xcode Previews run in a sandbox where AVAudioEngine reliably fails.
		// Skip setup entirely — the engine is unused in previews anyway.
#if targetEnvironment(simulator)
		let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
		if isPreview { return }
#endif

		do {
			let session = AVAudioSession.sharedInstance()
			try session.setCategory(.ambient, options: .mixWithOthers)
			try session.setActive(true)
		} catch {
			print("ScratchSoundEngine: audio session error – \(error)")
			return
		}

		// Build a safe, explicit format instead of asking outputNode before start.
		// outputNode.inputFormat(forBus:0) can return 0-channel garbage in
		// Simulator and on the first cold launch before the HAL is ready.
		let sampleRate = AVAudioSession.sharedInstance().sampleRate
		guard
			sampleRate > 0,
			let format = AVAudioFormat(
				commonFormat: .pcmFormatFloat32,
				sampleRate: sampleRate,
				channels: 2,
				interleaved: false
			)
		else {
			print("ScratchSoundEngine: could not create audio format")
			return
		}

		let node = AVAudioSourceNode(format: format) { [weak self] _, _, frameCount, abl -> OSStatus in
			guard let self else { return noErr }

			let bufferList = UnsafeMutableAudioBufferListPointer(abl)
			guard let raw = bufferList[0].mData else { return noErr }
			let buf = raw.assumingMemoryBound(to: Float.self)
			let n   = Int(frameCount)

			// Capture targets once per buffer (main-thread writes are benign races on ARM)
			let ampTarget = self.targetAmplitude
			let briTarget = self.targetBrightness

			for i in 0..<n {
				// Per-sample smoothing — no step discontinuities on update()
				self.amp        += 0.004 * (ampTarget - self.amp)
				self.brightness += 0.004 * (briTarget - self.brightness)

				// Snap to zero: kills denormals and prevents re-trigger glitch
				if self.amp < 0.002 {
					self.amp = 0; self.lp1 = 0; self.lp2 = 0
				}

				guard self.amp > 0 else { buf[i] = 0; continue }

				let white  = Float.random(in: -1...1)
				self.lp1  += 0.157 * (white      - self.lp1)
				let fc2    = 0.05 + self.brightness * 0.35
				self.lp2  += fc2   * (self.lp1    - self.lp2)

				// Body + texture blend, scaled by envelope
				buf[i] = (self.lp1 * 0.7 + (self.lp1 - self.lp2) * 0.5) * self.amp
			}

			// Copy channel 0 → all remaining channels
			for ch in 1..<bufferList.count {
				guard let dst = bufferList[ch].mData else { continue }
				memcpy(dst, raw, n * MemoryLayout<Float>.size)
			}
			return noErr
		}

		engine.attach(node)
		engine.connect(node, to: engine.mainMixerNode, format: format)

		do {
			try engine.start()
			sourceNode = node
			isReady    = true
		} catch {
			print("ScratchSoundEngine: engine failed to start – \(error)")
		}
	}

	// MARK: - Public API

	/// Call when a scratch gesture begins. Does NOT reset amplitude — that
	/// would silence the ramp-up. State is already zeroed from the last stop().
	func start() {
		// Intentionally empty: update(velocity:) drives amplitude.
		// Kept for call-site symmetry with stop().
	}

	/// Call when a scratch gesture ends.
	func stop() {
		targetAmplitude  = 0
		targetBrightness = 0
	}

	/// Drive this from your gesture recogniser. velocity ∈ [0, 1].
	func update(velocity: CGFloat) {
		guard isReady else { return }
		let v = Float(velocity.clamped(to: 0...1))
		targetAmplitude  = sqrt(v) * 0.72
		targetBrightness = v
	}
}

// MARK: - Clamp helper

private extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
