import SwiftUI

#Preview("Toolbar Full-Height Circles – Auto Width") {
	ToolbarFullHeightCirclesDemo()
}

struct ToolbarFullHeightCirclesDemo: View {
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Text("Content Area")
				Spacer()
			}
			.navigationTitle("Demo")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
//					FullHeightCircles()
					VStack(alignment: .leading) {
						FullHeightCircles()
					}.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
		}
	}
}

struct FullHeightCircles: View {
	private let count = 3

	@State private var height: CGFloat = 0
	@State private var overlap: CGFloat = 0   // 0 → 1

	private var spacing: CGFloat {
		-height * overlap
	}

	private var totalWidth: CGFloat {
		(height * CGFloat(count)) +
		(spacing * CGFloat(count - 1))
	}

	@State private var stackWidth: CGFloat = 0

	var body: some View {
		GeometryReader { proxy in
			let newHeight = proxy.size.height

			HStack(spacing: spacing) {
				ForEach(0..<count, id: \.self) { _ in
					Circle()
						.fill(Color.blue)
						.frame(width: newHeight, height: newHeight)
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
		}
		.onChange(of: height) { _, value in
			overlap = 1
			stackWidth = height
			withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
				overlap = 0.24
				stackWidth = totalWidth
			}
		}
		.frame(width: stackWidth)
		.fixedSize(horizontal: true, vertical: false)
	}
}
