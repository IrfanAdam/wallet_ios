import SwiftUI

struct DetentPlaneView<Content: View>: View {

	@Bindable var detents: DetentController
	let sheetGeometry: SheetGeometry
	let spacing: CGFloat
	let content: Content

	init(
		detents: DetentController,
		sheetGeometry: SheetGeometry,
		spacing: CGFloat,
		@ViewBuilder content: () -> Content
	) {
		self.detents = detents
		self.sheetGeometry = sheetGeometry
		self.spacing = spacing
		self.content = content()
	}

	var body: some View {
		VStack(spacing: spacing) {
			detentRow
			content
		}
		.padding()
	}

	private var detentRow: some View {
		HStack {
			ForEach(detents.heightVariants.indices, id: \.self) { index in
				Button(detents.heightVariants[index].id.capitalized) {
					detents.select(index: index)
				}
			}
			Button("Large") {
				detents.activeDetent = .large
			}
		}
	}
}
