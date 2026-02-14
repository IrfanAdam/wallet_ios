import SwiftUI

struct FullHeightCirclesCutout: View {
	@State private var context = FullHeightCirclesContext()
	@State private var heightRead: CGFloat = 0
	var body: some View {
		GeometryReader { proxy in
			HStack(alignment: .center, spacing: context.layout.spacing) {
				ForEach(0..<context.model.count, id: \.self) { index in
					FullHeightCutoutCircle(index: index)
				}
			}
			.padding(context.model.padding)
			.onAppear {
				heightRead = proxy.size.height
				context.updateCircSize(from: heightRead)
			}
			.onChange(of: proxy.size.height) { _, _ in
				heightRead = proxy.size.height
				context.updateCircSize(from: heightRead)
			}
		}
		.environment(context)
		.modifier(
			ContextCapsuleStackModifier(
				context: context
			)
		)
	}
}
