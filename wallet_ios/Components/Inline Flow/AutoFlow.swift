import SwiftUI

// MARK: - Layout Helpers (Separated from View)

func computeFlowRows(
	itemSizes: [CGSize],
	maxWidth: CGFloat,
	hSpacing: CGFloat
) -> [[Int]] {

	guard !itemSizes.isEmpty else { return [] }

	var rows: [[Int]] = [[]]
	var currentWidth: CGFloat = 0
	var rowIndex = 0

	for index in itemSizes.indices {
		let itemWidth = itemSizes[index].width

		if currentWidth + itemWidth + hSpacing > maxWidth {
			rowIndex += 1
			rows.append([index])
			currentWidth = itemWidth + hSpacing
		} else {
			rows[rowIndex].append(index)
			currentWidth += itemWidth + hSpacing
		}
	}

	return rows
}

func computeFlowHeight(
	rows: [[Int]],
	itemSizes: [CGSize],
	vSpacing: CGFloat
) -> CGFloat {

	var height: CGFloat = 0

	for (rowIndex, row) in rows.enumerated() {
		let rowHeight = row
			.map { itemSizes[$0].height }
			.max() ?? 0

		height += rowHeight

		if rowIndex < rows.count - 1 {
			height += vSpacing
		}
	}

	return height
}

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

// MARK: - SizeReader
struct SizeReader: View {
	var onChange: (CGSize) -> Void

	var body: some View {
		GeometryReader { geo in
			Color.clear
				.onAppear { onChange(geo.size) }
				.onChange(of: geo.size) { onChange($1) }
		}
	}
}

// MARK: - Sentence → AnyView Components
func sentenceToAnyViewComponents(
	_ sentence: String,
	transform: (String) -> AnyView
) -> [AnyView] {
	sentence.split(separator: " ").map {
		transform(String($0))
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
