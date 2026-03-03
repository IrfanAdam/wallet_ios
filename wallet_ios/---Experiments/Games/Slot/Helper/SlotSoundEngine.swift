import SwiftUI
import AVFoundation
import UIKit

final class SlotSoundEngine {
	
	private let engine   = AVAudioEngine()
	private let mixer    = AVAudioMixerNode()
	
	static let shared = SlotSoundEngine()
	
	private var spinTimer: DispatchSourceTimer?
	private var isSpinLoopActive = false
	
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
		play(
			frequency: 600,
			duration: 0.04,
			volume: 0.3,
			envelope: (0.001, 0.85),
			shape: .square,
			harmonics: [(2, 0.4), (3, 0.2)]
		)
		
		// metallic texture layer
		play(
			frequency: 0, // ignored
			duration: 0.015,
			volume: 0.25,
			envelope: (0.001, 0.9),
			shape: .noise
		)
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
//			let noise = Float.random(in: -0.2...0.2)
			let noise = Float.random(in: -0.3...0.3)
			
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
	
	func startSpinLoop() {
		guard !isSpinLoopActive else { return }
		isSpinLoopActive = true
		
		let queue = DispatchQueue(label: "slot.spin.loop")
		let timer = DispatchSource.makeTimerSource(queue: queue)
		
		timer.schedule(deadline: .now(), repeating: 0.06)
		timer.setEventHandler { [weak self] in
			self?.playSpinRuffle()
		}
		
		spinTimer = timer
		timer.resume()
	}
	
	func playSpinRuffle() {
		let duration: Float = 0.06
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
		
		var lowPassed: Float = 0
		var bandPassed: Float = 0
		
		for i in 0..<Int(frameCount) {
			
			let progress = Float(i) / Float(frameCount)
			
			// Base white noise
			let white = Float.random(in: -1...1)
			
			// Heavy low-pass to remove metallic highs
			lowPassed += 0.2 * (white - lowPassed)
			
			// Simple band emphasis in mid frequencies (cardboard texture)
			bandPassed += 0.24 * (lowPassed - bandPassed)
			
			// Soft rolling amplitude movement (friction variation)
			let slowWobble = 0.6 + 0.4 * sin(progress * .pi * Float.random(in: 1.5...3.0))
			
			// Smooth envelope (no sharp transient)
			let env = pow(1 - progress, 1.8)
			
			data[i] = bandPassed * slowWobble * env * 2.6
		}
		
		let player = AVAudioPlayerNode()
		engine.attach(player)
		engine.connect(player, to: mixer, format: format)
		player.scheduleBuffer(buffer, at: nil, options: .interrupts) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				self.engine.detach(player)
			}
		}
		player.play()
	}
	
	func stopSpinLoop() {
		spinTimer?.cancel()
		spinTimer = nil
		isSpinLoopActive = false
	}
}
