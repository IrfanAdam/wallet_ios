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

	private let engine = AVAudioEngine()
	private var sourceNode: AVAudioSourceNode!

	// Main-thread targets
	private var targetAmplitude: Float = 0
	private var targetBrightness: Float = 0

	// Audio-thread state
	private var amp: Float = 0
	private var brightness: Float = 0
	private var lp1: Float = 0   // body (low-pass)
	private var lp2: Float = 0   // texture (second pole)

	private init() {
		try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
		try? AVAudioSession.sharedInstance().setActive(true)

		let format = engine.outputNode.inputFormat(forBus: 0)

		sourceNode = AVAudioSourceNode(format: format) { [weak self] _, _, frameCount, abl -> OSStatus in
			guard let self else { return noErr }
			let ptr = UnsafeMutableAudioBufferListPointer(abl)
			guard let raw = ptr[0].mData else { return noErr }
			let buf = raw.assumingMemoryBound(to: Float.self)
			let n = Int(frameCount)

			let ampTarget  = self.targetAmplitude
			let briTarget  = self.targetBrightness

			for i in 0..<n {
				self.amp        += 0.004 * (ampTarget - self.amp)
				self.brightness += 0.004 * (briTarget - self.brightness)

				// Snap to zero — prevents denormal spin and re-trigger glitch
				if self.amp < 0.002 { self.amp = 0; self.lp1 = 0; self.lp2 = 0 }

				guard self.amp > 0 else { buf[i] = 0; continue }

				let white = Float.random(in: -1...1)
				self.lp1 += 0.157 * (white   - self.lp1)
				let fc2   = 0.05 + self.brightness * 0.35
				self.lp2 += fc2   * (self.lp1 - self.lp2)

				buf[i] = (self.lp1 * 0.7 + (self.lp1 - self.lp2) * 0.5) * self.amp
			}

			// Copy ch0 to all remaining channels
			for ch in 1..<ptr.count {
				guard let dst = ptr[ch].mData else { continue }
				memcpy(dst, raw, n * MemoryLayout<Float>.size)
			}
			return noErr
		}

		engine.attach(sourceNode)
		engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
		try? engine.start()
	}

	func start()  { targetAmplitude = 0 }
	func stop()   { targetAmplitude = 0; targetBrightness = 0 }

	func update(velocity: CGFloat) {
		let v = Float(min(max(velocity, 0), 1))
		targetAmplitude  = sqrt(v) * 0.72
		targetBrightness = v
	}
}

// MARK: - Comparable clamp helper

private extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
