import SwiftUI

#Preview {
	RewardSpinner()
}

struct RewardSpinner: View {
	let segments: Int = 8

	@State private var rotation: Double = 0
	@State private var lastRotation: Double = 0

	private let sensitivity: Double = 0.25
	private let momentumFactor: Double = 0.15

	var body: some View {
		ZStack {

			// Wheel
			Circle()
				.fill(.ultraThinMaterial)
				.overlay(
					SpinnerSegments(count: segments)
				)
				.frame(width: 260, height: 260)
				.rotationEffect(.degrees(rotation))
				.gesture(
					DragGesture()
						.onChanged { value in
							let delta = value.translation.width * sensitivity
							rotation = lastRotation + delta
						}
						.onEnded { value in
							handleMomentum(value)
						}
				)

			// Pointer
			TrianglePointer()
				.fill(.primary)
				.frame(width: 20, height: 20)
				.offset(y: -140)
		}
	}
}

private extension RewardSpinner {

	func handleMomentum(_ value: DragGesture.Value) {

		// 1️⃣ Calculate drag velocity
		let velocity = value.predictedEndTranslation.width - value.translation.width

		// 2️⃣ Convert to angular velocity
		let angularVelocity = velocity * sensitivity

		// 3️⃣ Add inertia (more spin if stronger flick)
		let extraRotation = angularVelocity * 8

		// 4️⃣ Ensure at least 1–2 full rotations for realism
		let minimumSpin = 720.0
		let projected = rotation + extraRotation

		let finalRaw = projected + minimumSpin

		// 5️⃣ Snap only at the very end
		let finalSnapped = snapToSegment(finalRaw)

		// 6️⃣ Animate with smooth deceleration
		withAnimation(.easeOut(duration: 2.2)) {
			rotation = finalSnapped
		}

		lastRotation = finalSnapped
	}


	func snapToSegment(_ angle: Double) -> Double {
		let segmentAngle = 360.0 / Double(segments)
		return (angle / segmentAngle).rounded() * segmentAngle
	}
}

struct SpinnerSegments: View {
	let count: Int

	var body: some View {
		ZStack {
			ForEach(0..<count, id: \.self) { index in
				SegmentShape(
					startAngle: .degrees(Double(index) * 360 / Double(count)),
					endAngle: .degrees(Double(index + 1) * 360 / Double(count))
				)
				.fill(index.isMultiple(of: 2) ? .blue.opacity(0.8) : .purple.opacity(0.8))
			}
		}
	}
}

struct SegmentShape: Shape {
	let startAngle: Angle
	let endAngle: Angle

	func path(in rect: CGRect) -> Path {
		var path = Path()
		let center = CGPoint(x: rect.midX, y: rect.midY)

		path.move(to: center)
		path.addArc(
			center: center,
			radius: rect.width / 2,
			startAngle: startAngle - .degrees(90),
			endAngle: endAngle - .degrees(90),
			clockwise: false
		)
		path.closeSubpath()

		return path
	}
}

struct TrianglePointer: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()

		path.move(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		path.closeSubpath()

		return path
	}
}
