import SwiftUI

struct SwipeToUnlock: View {
	let onUnlock: () -> Void
	@State private var x: CGFloat = 0
	@State private var completed = false
	let resetDelay: TimeInterval = 1.2
	let capsWidth: Int = 44
	private let swipeSpring = Animation.spring(
		response: 0.35,
		dampingFraction: 0.85
	)

	var body: some View {
		GeometryReader { g in
			let maxX = g.size.width - 54

			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 16)
					.background(.ultraThinMaterial)
					.clipShape(RoundedRectangle(cornerRadius: 16))
				RoundedRectangle(cornerRadius: 16).fill(
					completed ? .green.opacity(0.6) : .white.opacity(0.4)
				).frame(width: x + 54)
				RoundedRectangle(cornerRadius: 16)
					.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
					.frame(width: 54, height: 44)
					.buttonStyle(GlassButtonStyle())
					.offset(x: x)
					.gesture(
						DragGesture()
							.onChanged {
								guard !completed else { return }
								x = min(max(0, $0.translation.width), maxX)
							}
							.onEnded { _ in
								if x >= maxX {
									withAnimation(.spring()) {
										completed = true
										x = maxX
									}
									onUnlock()

									DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
										withAnimation(.spring()) {
											x = 0
											completed = false
										}
									}
								} else {
									withAnimation(.spring()) {
										x = 0
									}
								}
							}
					)
			}
		}
		.frame(height: 44)
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
			SwipeToUnlock {
				print("Unlocked")
			}
			.padding(32)

			GlassEffectContainer(spacing: 40.0) {
				HStack(spacing: 40.0) {
					Image(systemName: "scribble.variable")
						.frame(width: 80.0, height: 80.0)
						.font(.system(size: 36))
						.glassEffect()


					Image(systemName: "eraser.fill")
						.frame(width: 80.0, height: 80.0)
						.font(.system(size: 36))
						.glassEffect()
						.offset(x: -40.0, y: 0.0)
				}
			}

			ZStack(alignment: .center) {
				// 1️⃣ Bottom decorative glass
				RoundedRectangle(cornerRadius: 16)
					.glassEffect(.clear, in: .rect(cornerRadius: 16))
					.overlay(Color.blue.opacity(0.6).blendMode(.normal))
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.frame(height: 100)

				// 2️⃣ Middle thin material track
				RoundedRectangle(cornerRadius: 16)
					.background(.thinMaterial)               // frosted thin material
					.overlay(Color.white.opacity(0.15))       // subtle embedded tint
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.frame(width: 120, height: 80)

				// 3️⃣ Top interactive blob
				RoundedRectangle(cornerRadius: 200)
					.frame(width: 42, height: 42)
					.glassEffect(.regular.interactive())
					.offset(x: 0)                             // replace 0 with your drag offset
			}
			.padding(60)

			Text("Glass Content")
				.padding()
				.background {
					// Apply the effect in a specific shape
					Color.clear
						.glassEffect(in: RoundedRectangle(cornerRadius: 20))
						.tint(.blue.opacity(0.5))
				}

		}
	}
}
