import SwiftUI

struct SwipeToUnlock: View {
	let onUnlock: () -> Void
	let capSize: CGSize
	let trackHeight: CGFloat
	let resetDelay: TimeInterval = 1.2


	init(
		capSize: CGSize,
		trackHeight: CGFloat,
		onUnlock: @escaping () -> Void
	) {
		self.capSize = capSize
		self.trackHeight = trackHeight
		self.onUnlock = onUnlock
	}


	// MARK: – State
	@State private var x: CGFloat = 0
	@State private var completed = false

	private let swipeSpring = Animation.spring(
		response: 0.35,
		dampingFraction: 0.85
	)

	var body: some View {
		GeometryReader { g in
			let maxX = g.size.width - capSize.width

			ZStack(alignment: .leading) {

				// Track
				RoundedRectangle(cornerRadius: 20)
					.fill(.blue.opacity(0.4).blendMode(.multiply))
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.white.opacity(0.4), lineWidth: 1)
					)

				// Progress fill
				RoundedRectangle(cornerRadius: 20)
					.fill(completed ? .green.opacity(0.6) : .white.opacity(0.4))
					.frame(width: x + capSize.width)

				// Draggable cap
				SwipeCap(
					capSize: capSize,
					trackHeight: trackHeight,
					maxX: maxX,
					resetDelay: resetDelay,
					x: $x,
					completed: $completed
				) {
					onUnlock()
				}
			}
		}
		.frame(height: trackHeight)
	}
}
