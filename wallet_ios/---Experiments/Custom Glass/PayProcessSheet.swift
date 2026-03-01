import SwiftUI

struct LiminalGate: View {
	@State private var isVeiled = false

	var body: some View {
		ZStack {
			VStack(spacing: 24) {
				Text("Underlying Plane")
					.font(.largeTitle)

				Button("Poke Background") {
					print("background still alive")
				}
			}

			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					ForEach(0..<40, id: \.self) { i in
						Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Line \(i)")
							.font(.system(size: 18, weight: .medium))
					}
				}
				.padding(24)
			}

			Button("Summon Layer") {
				isVeiled = true
			}
			.buttonStyle(.borderedProminent)
		}
		.sheet(isPresented: $isVeiled) {
			ObsidianFold()
		}
		.toolbar {
			// Defines a toolbar item placed at the bottom
			ToolbarItem(placement: .bottomBar) {
				HStack {
					Image(systemName: "play.fill")
					Text("Now Playing - Accessory")
					Spacer()
					Button(action: {}) {
						Image(systemName: "xmark")
					}
				}
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(10)
			}
		}
		// Ensures visibility if needed, though default usually works
		.toolbarVisibility(.visible, for: .bottomBar)
	}
}

struct ObsidianFold: View {
	@State private var glyphHeight: CGFloat = 0
	@Environment(\.dismiss) private var vanish

	var body: some View {
		PhantomMeasure { h in
			glyphHeight = h
		} content: {
			VStack(spacing: 8) {

				SwipeToUnlock(
					capSize: CGSize(width: 60, height: 56),
					trackHeight: 56
				) {
					print("Unlocked")
				}
				.padding(16)


				Button("Recede") {
					vanish()
				}.foregroundStyle(.white)
			}
			.padding(.horizontal, 20)
			.padding(.vertical, 12)
		}
		.presentationDetents([.height(glyphHeight)])
		.presentationBackgroundInteraction(.enabled)
		.presentationContentInteraction(.resizes)
		.presentationDragIndicator(.hidden)
		.presentationBackground(Color.blue.opacity(0.8).blendMode(.plusDarker))
		.interactiveDismissDisabled()
		.presentationCompactAdaptation(.popover)
	}
}

struct PhantomMeasure<Content: View>: View {
	let onResolve: (CGFloat) -> Void
	let content: Content

	init(
		onResolve: @escaping (CGFloat) -> Void,
		@ViewBuilder content: () -> Content
	) {
		self.onResolve = onResolve
		self.content = content()
	}

	var body: some View {
		content
			.background(
				GeometryReader { proxy in
					Color.clear
						.onAppear {
							onResolve(proxy.size.height)
						}
						.onChange(of: proxy.size.height) { _, new in
							onResolve(new)
						}
				}
			)
	}
}

#Preview {
	LiminalGate()
}
