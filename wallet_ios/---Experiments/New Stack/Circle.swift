import SwiftUI

struct FullHeightCutoutCircle: View {
	let index: Int
	let height: CGFloat
	let count: Int
	let padded: CGFloat
	let overlap: CGFloat
	let animateSpace: Bool
	let spacing: CGFloat

	var body: some View {
		Circle()
			.fill(Color.blue)
			.frame(width: height, height: height)
			.overlay {
				if index < count - 1 {
					Circle()
						.frame(
							width: height + padded / 2,
							height: height + padded / 2
						)
						.offset(x: (height - padded) * (1 - overlap))
						.blendMode(.destinationOut)
				}
			}
			.opacity(animateSpace ? 1 : 0)
			.offset(x: animateSpace ? 0 : -(height + spacing) * CGFloat(index) * 0.5)
			.compositingGroup()
	}
}
