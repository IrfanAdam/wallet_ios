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

struct CustomGlass2: View {
	@State private var isHovered = false

	var body: some View {
		ZStack(alignment: .center) {
			RoundedRectangle(cornerRadius: 24)
				.glassEffect(
					.clear.tint(Color.blue.opacity(0.9)),
					in: .rect(cornerRadius: 24)
				)
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.frame(height: 100)

			RoundedRectangle(cornerRadius: 16)
				.fill(Color.blue) // optional fill/tint
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.stroke(
							Color.white.opacity(0.6),
							lineWidth: 1
						)
				)
				.clipShape(RoundedRectangle(cornerRadius: 16))
				.frame(width: 180, height: 60)
			HStack {
				Image(systemName: "scribble.variable")
					.foregroundStyle(Color.white)
					.frame(width: 42, height: 42)
					.background(
						RoundedRectangle(cornerRadius: 12)
							.glassEffect(
								.regular.tint(Color.blue).interactive(),
								in: .rect(cornerRadius: 12)
							)
					)
			}
		}
		.padding(60)
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
