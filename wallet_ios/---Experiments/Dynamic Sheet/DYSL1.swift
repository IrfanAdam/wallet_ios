
import SwiftUI

struct AuxiliaryPresentationPlane: View {

	@Environment(DetentController.self) private var detents
	@Binding var route: AuxiliaryRoute

	let sheetGeometry: SheetGeometry

	var body: some View {
		DetentPlaneView(
			detents: detents,
			sheetGeometry: sheetGeometry,
			spacing: 20
		) {
			Button("Go L2") {
				detents.resize(to: 320)
				route = .levelTwo
			}
			.buttonStyle(.glassProminent)
		}
	}
}
