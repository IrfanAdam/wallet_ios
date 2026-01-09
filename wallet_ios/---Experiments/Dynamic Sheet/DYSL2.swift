import SwiftUI

struct LevelTwoView: View {

	@Environment(DetentController.self) private var detents
	@Binding var route: AuxiliaryRoute

	let sheetGeometry: SheetGeometry

	var body: some View {
		DetentPlaneView(
			detents: detents,
			sheetGeometry: sheetGeometry,
			spacing: 16
		) {
			VStack {
				Button("Resize → 420") { detents.resize(to: 420) }
				Button("Resize → 480") { detents.resize(to: 480) }
			}
		}
	}
}
