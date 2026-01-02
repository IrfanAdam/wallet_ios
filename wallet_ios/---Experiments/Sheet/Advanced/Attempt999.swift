import SwiftUI

// MARK: - Height Variant Model

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

// MARK: - Root View

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented: Bool = false

	// UIKit-backed selection
	@State private var activeDetent: PresentationDetent

	// Ring of detents (acts like a buffer)
	@State private var heightVariants: [HeightVariant] = [
		.init(id: "s", height: 140),
		.init(id: "m", height: 320),
		.init(id: "l", height: 720)
	]

	// Track which slot is currently selected
	@State private var activeIndex: Int = 1

	init() {
		_activeDetent = State(initialValue: .height(240))
	}

	var body: some View {
		VStack(spacing: 24) {
			Text("Primary Interaction Surface")
				.font(.title2)

			Button("Invoke Secondary Plane") {
				isAuxiliaryPlanePresented.toggle()
			}
		}
		.padding()
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				AuxiliaryPresentationPlane(
					heightVariants: $heightVariants,
					activeIndex: $activeIndex,
					activeDetent: $activeDetent
				)
			}
			.presentationDetents(
				Set(heightVariants.map { .height($0.height) } + [.medium, .large]),
				selection: $activeDetent
			)
			.presentationBackground(Color.white)
			.presentationDragIndicator(.hidden)
		}
	}
}

// MARK: - Sheet Content

struct AuxiliaryPresentationPlane: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent

	var body: some View {

		VStack(spacing: 20) {

			HStack(spacing: 12) {
				ForEach(heightVariants.indices, id: \.self) { index in
					Button(heightVariants[index].id.capitalized) {
						select(index)
					}
					.buttonStyle(.borderedProminent)
				}

				Button("Native Large") {
					activeDetent = .large
				}
			}


				NavigationLink("Go L2") {
					levelTwo
				}
				.buttonStyle(.glassProminent)

		}
		.toolbarVisibility(.visible, for: .navigationBar)
		.padding(.horizontal)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
	}

	// MARK: - Level Two

	private var levelTwo: some View {
		VStack(spacing: 12) {
			HStack(spacing: 12) {
				ForEach(heightVariants.indices, id: \.self) { index in
					Button(heightVariants[index].id.capitalized) {
						select(index)
					}
					.buttonStyle(.borderedProminent)
				}
				Button("Native Large") {
					activeDetent = .large
				}
			}

			Button("Resize → 420") {
				rotateAndResize(to: 420)
			}

			Button("Resize → 480") {
				rotateAndResize(to: 480)
			}
		}
		.padding()
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
		.background(Color.white)
		.navigationTitle("Look ma we made it")
	}

	// MARK: - Helpers

	private func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	/// Core trick:
	/// - advance index
	/// - mutate *next* detent
	/// - select it
	private func rotateAndResize(to newHeight: CGFloat) {
		let nextIndex = (activeIndex + 1) % heightVariants.count

		heightVariants[nextIndex].height = newHeight
		activeIndex = nextIndex
		activeDetent = .height(newHeight)
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
