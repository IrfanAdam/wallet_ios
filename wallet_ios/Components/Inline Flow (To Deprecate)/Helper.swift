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
