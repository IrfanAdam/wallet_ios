import SwiftUI

// MARK: - Height Variant Model

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

// MARK: - Root View

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented: Bool = false

	// Active UIKit-backed selection
	@State private var activeDetent: PresentationDetent

	// State-driven height variants (collection)
	@State private var heightVariants: [HeightVariant] = [
		.init(id: "medium", height: 120),
		.init(id: "tall", height: 320),
		.init(id: "large", height: 720)
	]

	// Track logical selection (optional but keeps intent clear)
	@State private var activeVariantID: HeightVariant.ID? = "medium"

	init() {
		_activeDetent = State(initialValue: .height(480))
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
			AuxiliaryPresentationPlane(
				heightVariants: $heightVariants,
				activeVariantID: $activeVariantID,
				activeDetent: $activeDetent
			)
			.presentationDetents(
				Set(heightVariants.map { .height($0.height) } + [.large]),
				selection: $activeDetent
			)
			.presentationBackground(Color.black)
		}
	}
}

// MARK: - Sheet Content

struct AuxiliaryPresentationPlane: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeVariantID: HeightVariant.ID?
	@Binding var activeDetent: PresentationDetent

	var body: some View {
		VStack(spacing: 20) {
			HStack(spacing: 16) {
				ForEach(heightVariants) { variant in
					Button(variant.id.capitalized) {
						select(variant)
					}
					.buttonStyle(.borderedProminent)
				}

				Button() {
					activeDetent = .large
				} label: {
					Text("Make Large")
				}
			}

		}
		.padding(32)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
	}

	// MARK: - Helpers

	private func select(_ variant: HeightVariant) {
		activeVariantID = variant.id
		activeDetent = .height(variant.height)
	}

	private func heightBinding(for variant: HeightVariant) -> Binding<Double> {
		Binding<Double>(
			get: { variant.height },
			set: { newValue in
				updateHeight(id: variant.id, newHeight: newValue)
			}
		)
	}

	private func updateHeight(id: String, newHeight: CGFloat) {
		guard let index = heightVariants.firstIndex(where: { $0.id == id }) else { return }

		heightVariants[index].height = newHeight

		// Keep UIKit selection valid
		if activeVariantID == id {
			activeDetent = .height(newHeight)
		}
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
