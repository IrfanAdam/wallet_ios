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
			.fill(Color.black)
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

// MARK: - Rounded Triangle Shape
struct TrianglePointer: Shape {

	var cornerRadius: CGFloat = 4

	func path(in rect: CGRect) -> Path {
		let tip   = CGPoint(x: rect.midX, y: rect.maxY)   // points DOWN
		let left  = CGPoint(x: rect.minX, y: rect.minY)
		let right = CGPoint(x: rect.maxX, y: rect.minY)

		let radius = min(cornerRadius,
										 rect.width / 2,
										 rect.height / 2)

		var path = Path()

		// Helper to round between two lines
		func addRoundedCorner(from p1: CGPoint,
													corner: CGPoint,
													to p2: CGPoint) {

			let v1 = CGVector(dx: p1.x - corner.x, dy: p1.y - corner.y)
			let v2 = CGVector(dx: p2.x - corner.x, dy: p2.y - corner.y)

			let len1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy)
			let len2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy)

			let n1 = CGVector(dx: v1.dx / len1, dy: v1.dy / len1)
			let n2 = CGVector(dx: v2.dx / len2, dy: v2.dy / len2)

			let start = CGPoint(
				x: corner.x + n1.dx * radius,
				y: corner.y + n1.dy * radius
			)

			let end = CGPoint(
				x: corner.x + n2.dx * radius,
				y: corner.y + n2.dy * radius
			)

			path.addLine(to: start)
			path.addQuadCurve(to: end, control: corner)
		}

		path.move(to: tip)

		addRoundedCorner(from: right, corner: tip, to: left)
		addRoundedCorner(from: tip, corner: left, to: right)
		addRoundedCorner(from: left, corner: right, to: tip)

		path.closeSubpath()

		return path
	}
}
