import SwiftUI

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
			let maxWidth = geo.size.width
			let rows = computeRows(maxWidth: maxWidth)
			let height = computeHeight(for: rows)

			VStack(alignment: .leading, spacing: vSpacing) {
				ForEach(rows.indices, id: \.self) { rowIndex in
					HStack(spacing: hSpacing) {
						ForEach(rows[rowIndex], id: \.self) { index in
							items[index]
								.fixedSize() // avoid unnecessary resizing
								.background(
									SizeReader { size in
										DispatchQueue.main.async {
											sizes[index] = size
										}
									}
								)
						}
					}
				}
			}
			.onAppear {
				computedHeight = height
			}
			.onChange(of: height) {
				computedHeight = height
			}
		}
		.padding(.horizontal)
		.frame(height: computedHeight)
	}

	private func computeRows(maxWidth: CGFloat) -> [[Int]] {
		var rows: [[Int]] = [[]]
		var currentWidth: CGFloat = 0
		var rowIndex = 0

		for index in items.indices {
			let itemWidth = sizes[index].width

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


	private func computeHeight(for rows: [[Int]]) -> CGFloat {
		var height: CGFloat = 0

		for (rowIndex, row) in rows.enumerated() {
			let rowHeight = row
				.map { sizes[$0].height }
				.max() ?? 0

			height += rowHeight

			if rowIndex < rows.count - 1 {
				height += vSpacing
			}
		}

		return height
	}


}

// MARK: --- SizeReader ---
struct SizeReader: View {
	var onChange: (CGSize) -> Void

	var body: some View {
		GeometryReader { geo in
			Color.clear
				.onAppear {
					onChange(geo.size)
				}
				.onChange(of: geo.size) {
					onChange(geo.size)  // no parameters needed
				}
		}
	}

}



// MARK: --- Example Pill ---
struct Pill: View {
	let text: String

	 
	var body: some View {
		Text(text)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(Capsule().stroke(Color.gray, lineWidth: 1))
	}
}

func sentenceToAnyViewComponents(
	_ sentence: String,
	transform: (String) -> AnyView
) -> [AnyView] {
	sentence.split(separator: " ").map { word in
		transform(String(word))
	}
}


