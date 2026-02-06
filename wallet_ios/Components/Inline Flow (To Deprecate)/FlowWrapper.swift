import SwiftUI

// MARK: - SimpleFlowWrap
struct SimpleFlowWrap: View {
	let items: [AnyView]
	let hSpacing: CGFloat = 6
	let vSpacing: CGFloat = 0

	@State private var sizes: [CGSize]
	@State private var computedHeight: CGFloat = 0

	init(items: [AnyView]) {
		self.items = items
		_sizes = State(initialValue: Array(repeating: .zero, count: items.count))
	}

	var body: some View {
		GeometryReader { geo in
			let rows = computeFlowRows(
				itemSizes: sizes,
				maxWidth: geo.size.width,
				hSpacing: hSpacing
			)

			let height = computeFlowHeight(
				rows: rows,
				itemSizes: sizes,
				vSpacing: vSpacing
			)

			VStack(alignment: .leading, spacing: vSpacing) {
				ForEach(rows.indices, id: \.self) { rowIndex in
					HStack(spacing: hSpacing) {
						ForEach(rows[rowIndex], id: \.self) { index in
							items[index]
								.fixedSize()
								.background(
									SizeReader { size in
										sizes[index] = size
									}
								)
						}
					}
				}
			}
			.onAppear { computedHeight = height }
			.onChange(of: height) { computedHeight = height }
		}
		.frame(height: computedHeight)
	}
}

// MARK: - Preview
#Preview {
	SimpleFlowWrap(
		items: sentenceToAnyViewComponents("This is a flowing pill layout") {
			AnyView(Pill(text: $0))
		}
	)
	.padding()
}
