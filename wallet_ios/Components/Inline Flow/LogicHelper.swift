import SwiftUI

enum FlowItemNew: Hashable {
	case text(String, Tone)
	case pill(String)
}

enum Tone {
	case primary
	case secondary

	var color: Color {
		switch self {
		case .primary: return Color(red: 0.11, green: 0.18, blue: 0.23)
		case .secondary: return Color(red: 0.4, green: 0.47, blue: 0.53)
		}
	}
}

struct FlowLayout: Layout {
	var hSpacing: CGFloat = 6
	var vSpacing: CGFloat = 0

	func sizeThatFits(
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) -> CGSize {
		let maxWidth = proposal.width ?? .infinity
		var x: CGFloat = 0
		var y: CGFloat = 0
		var rowHeight: CGFloat = 0

		for subview in subviews {
			let size = subview.sizeThatFits(.unspecified)

			if x + size.width > maxWidth {
				x = 0
				y += rowHeight + vSpacing
				rowHeight = 0
			}

			x += size.width + hSpacing
			rowHeight = max(rowHeight, size.height)
		}

		return CGSize(width: maxWidth, height: y + rowHeight)
	}

	func placeSubviews(
		in bounds: CGRect,
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout ()
	) {
		var x = bounds.minX
		var y = bounds.minY
		var rowHeight: CGFloat = 0

		for subview in subviews {
			let size = subview.sizeThatFits(.unspecified)

			if x + size.width > bounds.maxX {
				x = bounds.minX
				y += rowHeight + vSpacing
				rowHeight = 0
			}

			subview.place(
				at: CGPoint(
					x: x,
					y: y - (size.height) / 2
				),
				proposal: ProposedViewSize(size)
			)

			x += size.width + hSpacing
			rowHeight = max(rowHeight, size.height)
		}
	}
}
