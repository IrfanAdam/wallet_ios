import SwiftUI

struct AuxiliaryPresentationPlane: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent
	@Binding var route: AuxiliaryRoute

	let sheetGeometry: SheetGeometry

	var body: some View {
		AuxiliaryPlaneContainer(
			heightVariants: $heightVariants,
			activeIndex: $activeIndex,
			activeDetent: $activeDetent,
			route: $route,
			sheetGeometry: sheetGeometry
		) { resize in

			Button("Go L2") {
				withAnimation(.easeInOut(duration: 0.35)) {
					resize(320)
					route = .levelTwo
				}
			}
			.buttonStyle(.glassProminent)
		}
	}
}
