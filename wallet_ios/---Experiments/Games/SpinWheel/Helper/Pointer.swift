import SwiftUI
import Charts
import AVFoundation

// MARK: - Tick Sound Player
final class TickSoundPlayer {
	static let shared = TickSoundPlayer()
	private var players: [AVAudioPlayer] = []
	
	func tick(intensity: Double = 1.0) {
		// Use system sound as fallback, or load a custom tick.wav from bundle
		AudioServicesPlaySystemSound(1157) // crisp tick sound
	}
}

// MARK: - Pointer View (reactive)
struct SpinnerPointer: View {
	let rotation: Double
	let segmentCount: Int
	
	@State private var wobble: Double = 0
	@State private var lastSegmentIndex: Int = -1
	@State private var lastRotation: Double = 0
	
	private var segmentAngle: Double { 360.0 / Double(segmentCount) }
	
	private var currentBoundaryIndex: Int {
		let normalized = rotation.truncatingRemainder(dividingBy: 360)
		let positive = normalized < 0 ? normalized + 360 : normalized
		return Int((positive / segmentAngle).rounded()) % segmentCount
	}
	
	// Positive = clockwise, negative = counter-clockwise
	private var spinDirection: Double {
		rotation - lastRotation > 0 ? 1 : -1
	}
	
	var body: some View {
		TrianglePointer()
			.fill(.primary)
			.frame(width: 22, height: 22)
			.rotationEffect(.degrees(wobble), anchor: .bottom)
			.onChange(of: currentBoundaryIndex) { _, newIndex in
				guard newIndex != lastSegmentIndex else { return }
				lastSegmentIndex = newIndex
				triggerTick()
			}
			.onChange(of: rotation) { _, newRotation in
				lastRotation = newRotation
			}
	}
	
	private func triggerTick() {
		TickSoundPlayer.shared.tick()
		
		// Wobble AGAINST the spin direction
		let deflection = -18.0 * spinDirection
		
		withAnimation(.interpolatingSpring(mass: 0.3, stiffness: 300, damping: 6)) {
			wobble = deflection
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
			withAnimation(.interpolatingSpring(mass: 0.3, stiffness: 200, damping: 8)) {
				wobble = 0
			}
		}
	}
}

// MARK: - Triangle Shape
struct TrianglePointer: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		let tip   = CGPoint(x: rect.midX, y: rect.maxY)  // tip points DOWN
		let left  = CGPoint(x: rect.minX, y: rect.minY)
		let right = CGPoint(x: rect.maxX, y: rect.minY)
		
		path.move(to: tip)
		path.addLine(to: left)
		path.addLine(to: right)
		path.closeSubpath()
		
		return path
	}
}
