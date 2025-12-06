import SwiftUI

struct SimpleFlowWrap: View {
	let items: [AnyView]
	let spacing: CGFloat = 6

	 
	@State private var sizes: [CGSize]

	init(items: [AnyView]) {
		self.items = items
		_sizes = State(initialValue: Array(repeating: .zero, count: items.count))
	}

	var body: some View {
		GeometryReader { geo in
			let maxWidth = geo.size.width
			let rows = computeRows(maxWidth: maxWidth)

			VStack(alignment: .leading, spacing: spacing) {
				ForEach(rows.indices, id: \.self) { rowIndex in
					HStack(spacing: spacing) {
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
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding()
	}

	private func computeRows(maxWidth: CGFloat) -> [[Int]] {
		var rows: [[Int]] = [[]]
		var currentWidth: CGFloat = 0
		var rowIndex = 0

		for index in items.indices {
			let itemWidth = sizes[index].width

			if currentWidth + itemWidth + spacing > maxWidth {
				rowIndex += 1
				rows.append([index])
				currentWidth = itemWidth + spacing
			} else {
				rows[rowIndex].append(index)
				currentWidth += itemWidth + spacing
			}
		}
		return rows
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


