import SwiftUI

struct FullHeightCirclesCutout: View {
	private let count = 3

	@State private var height: CGFloat = 0
	@State private var overlap: CGFloat = 0.12
	@State private var animateSpace: Bool = false
	@State private var stackWidth: CGFloat = 0

	private var spacing: CGFloat {
		-height * overlap
	}

	private var totalWidth: CGFloat {
		(height * CGFloat(count)) +
		(spacing * CGFloat(count - 1)) + padded * 2
	}

	private let padded: CGFloat = 4

	var body: some View {
		GeometryReader { proxy in
			let newHeight = max(proxy.size.height - padded * 2, 0)

			HStack(alignment: .center, spacing: spacing) {
				ForEach(0..<count, id: \.self) { index in
//					circle(index: index, height: newHeight)
					FullHeightCutoutCircle(
						index: index,
						height: newHeight,
						count: count,
						padded: padded,
						overlap: overlap,
						animateSpace: animateSpace,
						spacing: spacing
					)
				}
			}
			.onAppear {
				if height == 0 {
					height = newHeight
				}
			}
			.onChange(of: newHeight) { _, value in
				height = value
			}
			.padding(padded)
		}
		.modifier(
			ExpandingCapsuleStackModifier(
				height: $height,
				animateSpace: $animateSpace,
				stackWidth: $stackWidth,
				totalWidth: totalWidth
			)
		)
	}
}
