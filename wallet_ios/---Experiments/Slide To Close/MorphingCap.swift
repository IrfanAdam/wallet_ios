import SwiftUI

struct SwipeCap: View {
	let capSize: CGSize
	let trackHeight: CGFloat
	let maxX: CGFloat
	let resetDelay: TimeInterval

	@Binding var x: CGFloat
	@Binding var completed: Bool

	let onComplete: () -> Void

	private let swipeSpring = Animation.spring(
		response: 0.35,
		dampingFraction: 0.85
	)

	var body: some View {
		NativeGlassHost(
			tintColor: UIColor(
				red: 0 / 255,
				green: 111 / 255,
				blue: 235 / 255,
				alpha: 0.9
			),
			interactive: true,
			cornerRadius: 20
		) {
			HStack {
				Image(systemName: "chevron.right.2")
					.foregroundColor(.white)
					.frame(width: capSize.width, height: trackHeight)
//					.background(
//						NativeGlass(
//							tintColor: UIColor(
//								red: 0 / 255,
//								green: 111 / 255,
//								blue: 235 / 255,
//								alpha: 0.9
//							),
//							interactive: true,
//							cornerRadius: 20
//						)
//						.frame(width: capSize.width, height: capSize.height)
//					)
			}
		}
		.frame(width: capSize.width, height: trackHeight)
		.offset(x: x)
		.gesture(
			DragGesture()
				.onChanged { value in
					guard !completed else { return }
					x = min(max(0, value.translation.width), maxX)
				}
				.onEnded { _ in
					if x >= maxX {
						withAnimation(swipeSpring) {
							completed = true
							x = maxX
						}
						onComplete()

						DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
							withAnimation(swipeSpring) {
								x = 0
								completed = false
							}
						}
					} else {
						withAnimation(swipeSpring) {
							x = 0
						}
					}
				}
		)
	}
}
