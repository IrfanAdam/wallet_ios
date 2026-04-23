import SwiftUI

struct GlassNoFlickerDemo: View {
	@Namespace private var animation
	@State private var selected = 0
	@State private var pressed = false

	let items = [
		("house.fill", "Home"),
		("magnifyingglass", "Search"),
		("bell.fill", "Alerts")
	]

	var body: some View {
		ZStack {
			LinearGradient(
				colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()

			VStack {
				Spacer()

				GlassEffectContainer {
					HStack(spacing: 12) {

						// Segments
						HStack(spacing: 8) {
							ForEach(items.indices, id: \.self) { index in
								let item = items[index]

								Button {
									withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
										selected = index
									}
								} label: {
									VStack(spacing: 4) {
										Image(systemName: item.0)
											.font(.system(size: 18, weight: .semibold))

										Text(item.1)
											.font(.caption2.weight(.medium))
									}
									.foregroundStyle(
										selected == index ? .white : .white.opacity(0.75)
									)
									.frame(maxWidth: .infinity)
									.frame(height: 52)
									.contentShape(Rectangle())
									.background {
										if selected == index {
											RoundedRectangle(cornerRadius: 32, style: .continuous)
												.fill(.white.opacity(0.18))
												.matchedGeometryEffect(
													id: "ACTIVE_TAB",
													in: animation
												)
										}
									}
								}
								.buttonStyle(.plain)
							}
						}
						.padding(6)
						.glassEffect(
							.clear
								.interactive(true)
								.tint(.white.opacity(0.22)),
							in: Capsule()
						)

						// Action Button
						Button {
							withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
								pressed.toggle()
							}
						} label: {
							Image(systemName: pressed ? "heart.fill" : "heart")
								.font(.system(size: 20, weight: .semibold))
								.foregroundStyle(.white)
								.frame(width: 50, height: 50)
						}
						.buttonStyle(.plain)
						.glassEffect(
							.clear
								.interactive(true)
								.tint(.pink.opacity(0.65)),
							in: Circle()
						)
					}
					.padding(.horizontal, 16)
					.padding(.vertical, 10)
				}
				.padding(.horizontal, 20)
				.padding(.bottom, 34)
			}
		}
	}
}

#Preview {
	GlassNoFlickerDemo()
}
