import SwiftUI

struct LevelTwoView: View {

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

			VStack(spacing: 12) {
				Text("You can test any content style here")
				
				Button("Resize → 420") {
					resize(420)
				}

				Button("Resize → 480") {
					resize(480)
				}
			}
		}
	}
}
