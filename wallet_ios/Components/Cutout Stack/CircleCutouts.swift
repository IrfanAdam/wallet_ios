import SwiftUI

struct FullHeightCirclesCutout: View {
//	@State private var context = FullHeightCirclesContext()

	@State private var context: FullHeightCirclesContext
	let avatars: [AvatarData]

	init(
		avatars: [AvatarData],
		style: AvatarStyle
	) {
		self.avatars = avatars
		_context = State(
			initialValue: FullHeightCirclesContext(
				count: avatars.count,
				style: style
			)
		)
	}

	@State private var heightRead: CGFloat = 0

	var body: some View {
		GeometryReader { proxy in
			HStack(alignment: .center, spacing: context.layout.spacing) {
				ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in
					FullHeightCutoutCircle(
						index: index,
						avatar: avatar,
						totalCount: avatars.count
					)
				}
			}
			.padding(context.model.style.strokeWidth)
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
