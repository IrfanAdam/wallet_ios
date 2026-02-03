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
				Image(systemName: "scribble.variable")
					.foregroundColor(.white)
					.frame(width: capSize.width, height: trackHeight)
					.background(
						NativeGlass(
							tintColor: UIColor(
								red: 0/255,
								green: 111/255,
								blue: 235/255,
								alpha: 0.9
							),
							interactive: true,
							cornerRadius: 20
						)
						.frame(width: capSize.width, height: capSize.height)
					)
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
									onUnlock()

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
		.frame(height: trackHeight)
	}
}


#Preview {
	ZStack {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				ForEach(0..<40, id: \.self) { i in
					Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Line \(i)")
						.font(.system(size: 18, weight: .medium))
				}
			}
			.padding(24)
		}.background(.white)

		VStack {
			SwipeToUnlock(
				capSize: CGSize(width: 56, height: 52),
				trackHeight: 44
			) {
				print("Unlocked")
			}
			.padding(32)

			GlassEffectContainer(spacing: 40.0) {
				HStack(spacing: 48.0) {
					Image(systemName: "scribble.variable")
						.frame(width: 80.0, height: 80.0)
						.font(.system(size: 36))
						.glassEffect(.regular.interactive())


					Image(systemName: "eraser.fill")
						.frame(width: 60.0, height: 60.0)
						.font(.system(size: 32))
						.glassEffect(.regular.interactive())
						.offset(x: -40.0, y: 0.0)
				}
			}

			CustomGlass()
		}
	}
}
