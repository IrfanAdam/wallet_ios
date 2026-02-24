import SwiftUI
import AVFoundation
import UIKit

// MARK: - Sound Engine

final class SlotSoundEngine {

	private let engine   = AVAudioEngine()
	private let mixer    = AVAudioMixerNode()

	static let shared = SlotSoundEngine()

	private init() {
		engine.attach(mixer)
		engine.connect(mixer, to: engine.mainMixerNode, format: nil)
		try? engine.start()
	}

	// ── Synthesis helpers ──────────────────────────────────────────────────

	/// Generates a short PCM tone and plays it immediately.
	func play(
		frequency: Float,
		duration: Float,
		volume: Float = 0.5,
		envelope: (attack: Float, decay: Float) = (0.01, 0.3),
		shape: WaveShape = .sine,
		harmonics: [(mult: Float, amp: Float)] = []
	) {
		let sampleRate: Double = 44_100
		let frameCount = AVAudioFrameCount(sampleRate * Double(duration))
		guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
					let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }

		buffer.frameLength = frameCount
		let data = buffer.floatChannelData![0]

		for i in 0 ..< Int(frameCount) {
			let t    = Float(i) / Float(sampleRate)
			let norm = Float(i) / Float(frameCount)       // 0→1

			// Envelope
			let attackEnd  = envelope.attack
			let decayStart = 1.0 - envelope.decay
			let env: Float
			if norm < attackEnd {
				env = norm / attackEnd
			} else if norm > decayStart {
				env = 1.0 - (norm - decayStart) / envelope.decay
			} else {
				env = 1.0
			}

			// Wave
			var sample: Float
			switch shape {
			case .sine:
				sample = sin(2 * .pi * frequency * t)
			case .square:
				sample = sin(2 * .pi * frequency * t) >= 0 ? 1.0 : -1.0
			case .noise:
				sample = Float.random(in: -1...1)
			}

			// Optional harmonics
			for h in harmonics {
				sample += h.amp * sin(2 * .pi * frequency * h.mult * t)
			}

			data[i] = sample * env * volume
		}

		// Schedule on a fresh player node (fire-and-forget)
		let player = AVAudioPlayerNode()
		engine.attach(player)
		engine.connect(player, to: mixer, format: format)
		player.scheduleBuffer(buffer, at: nil, options: .interrupts) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.engine.detach(player)
			}
		}
		player.play()
	}

	enum WaveShape { case sine, square, noise }

	// ── Named events ───────────────────────────────────────────────────────

	/// Short mid-frequency pop — lever grabbed
	func playGrab() {
		play(frequency: 320, duration: 0.07, volume: 0.55,
				 envelope: (0.005, 0.6), shape: .sine,
				 harmonics: [(2, 0.3), (3, 0.1)])
	}

	/// Quick soft tick — ratchet while dragging
	func playTick() {
		play(frequency: 900, duration: 0.03, volume: 0.25,
				 envelope: (0.002, 0.8), shape: .sine)
	}

	/// Heavy low thud — lever seats into trigger slot
	func playLockIn() {
		// Two-layer: sub thud + high transient
		play(frequency: 80,  duration: 0.12, volume: 0.65,
				 envelope: (0.003, 0.5), shape: .sine)
		play(frequency: 600, duration: 0.05, volume: 0.35,
				 envelope: (0.002, 0.9), shape: .square)
	}

	/// Softer de-latch click — backing above threshold
	func playUnlatch() {
		play(frequency: 500, duration: 0.05, volume: 0.30,
				 envelope: (0.003, 0.7), shape: .sine,
				 harmonics: [(2, 0.2)])
	}

	/// Sharp mechanical snap — lever released and snaps back
	func playSnap() {

		let duration: Float = 0.08
		let sampleRate: Double = 44_100
		let frameCount = AVAudioFrameCount(sampleRate * Double(duration))

		guard let format = AVAudioFormat(
			standardFormatWithSampleRate: sampleRate,
			channels: 1
		),
					let buffer = AVAudioPCMBuffer(
						pcmFormat: format,
						frameCapacity: frameCount
					) else { return }

		buffer.frameLength = frameCount
		let data = buffer.floatChannelData![0]

		for i in 0..<Int(frameCount) {

			let t = Float(i) / Float(sampleRate)
			let progress = Float(i) / Float(frameCount)

			// 🔻 Downward pitch sweep (spring recoil)
			let startFreq: Float = 220
			let endFreq: Float = 140
			let freq = startFreq - (startFreq - endFreq) * progress

			// Envelope (tight)
			let attack: Float = 0.002
			let decay: Float = 0.5

			let env: Float
			if progress < attack {
				env = progress / attack
			} else {
				env = pow(1 - progress, decay * 3)
			}

			// Slight mechanical noise
			let noise = Float.random(in: -0.2...0.2)

			let sample =
			sin(2 * .pi * freq * t) * 0.8 +
			noise * 0.2

			data[i] = sample * env * 0.7
		}

		let player = AVAudioPlayerNode()
		engine.attach(player)
		engine.connect(player, to: mixer, format: format)
		player.scheduleBuffer(buffer, at: nil, options: .interrupts) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				self.engine.detach(player)
			}
		}
		player.play()
	}

	/// Ascending two-note chime — reels begin to spin
	func playSpinTrigger() {
		play(frequency: 520, duration: 0.10, volume: 0.50,
				 envelope: (0.01, 0.4), shape: .sine)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
			self.play(frequency: 780, duration: 0.15, volume: 0.55,
								envelope: (0.01, 0.5), shape: .sine,
								harmonics: [(2, 0.15)])
		}
	}

	/// Soft click — knob returns without triggering
	func playAbort() {
		play(frequency: 260, duration: 0.06, volume: 0.30,
				 envelope: (0.005, 0.6), shape: .sine)
	}
}

// MARK: - Lever View

struct SlotLever: View {

	let reelHeight: CGFloat
	let isSpinning: Bool
	let onPulled: () -> Void

	@State private var dragOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var lastTickOffset: CGFloat = 0
	@State private var hasLockedIn = false

	private let knobSize: CGFloat = 36
	private let triggerThresholdRatio: CGFloat = 0.95
	private let tickSpacing: CGFloat = 18

	private let grabFeedback    = UIImpactFeedbackGenerator(style: .medium)
	private let tickFeedback    = UISelectionFeedbackGenerator()
	private let lockFeedback    = UIImpactFeedbackGenerator(style: .heavy)
	private let releaseFeedback = UIImpactFeedbackGenerator(style: .rigid)
	private let spinFeedback    = UINotificationFeedbackGenerator()

	private let sounds = SlotSoundEngine.shared

	var body: some View {

		ZStack(alignment: .top) {

			Capsule()
				.fill(Color.black.opacity(0.15))
				.frame(width: knobSize, height: reelHeight)

			Circle()
				.fill(Color.blue)
				.frame(width: knobSize, height: knobSize)
				.offset(y: dragOffset)
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							guard !isSpinning else { return }

							// ── GRAB ──────────────────────────────────────
							if !isDragging {
								isDragging     = true
								lastTickOffset = 0
								hasLockedIn    = false

								grabFeedback.prepare()
								tickFeedback.prepare()
								lockFeedback.prepare()

								grabFeedback.impactOccurred(intensity: 0.85)
								sounds.playGrab()
							}

							let maxOffset = reelHeight - knobSize
							dragOffset    = min(max(0, value.translation.height), maxOffset)

							// ── DRAG TICKS ────────────────────────────────
							if abs(dragOffset - lastTickOffset) >= tickSpacing {
								tickFeedback.selectionChanged()
								sounds.playTick()
								lastTickOffset = dragOffset
							}

							// ── THRESHOLD LOCK-IN ─────────────────────────
							let overThreshold = dragOffset > maxOffset * triggerThresholdRatio
							if overThreshold && !hasLockedIn {
								hasLockedIn = true
								lockFeedback.impactOccurred(intensity: 1.0)
								sounds.playLockIn()
							} else if !overThreshold && hasLockedIn {
								hasLockedIn = false
								releaseFeedback.impactOccurred(intensity: 0.6)
								sounds.playUnlatch()
							}
						}
						.onEnded { _ in
							guard !isSpinning else { return }

							let maxOffset  = reelHeight - knobSize
							let didTrigger = dragOffset > maxOffset * triggerThresholdRatio

							withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
								dragOffset = 0
							}

							if didTrigger {
								// ── RELEASE + SPIN ────────────────────────
								releaseFeedback.impactOccurred(intensity: 1.0)
								sounds.playSnap()

								DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
									spinFeedback.notificationOccurred(.success)
									sounds.playSpinTrigger()
								}

								onPulled()
							} else {
								// ── ABORT ─────────────────────────────────
								releaseFeedback.impactOccurred(intensity: 0.45)
								sounds.playAbort()
							}

							isDragging  = false
							hasLockedIn = false
						}
				)
		}
		.frame(width: 40, height: reelHeight)
	}
}
