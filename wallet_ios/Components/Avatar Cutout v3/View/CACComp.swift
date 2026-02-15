import SwiftUI

struct CutoutAvatarStack: View {
	
	@State private var context: CutoutAvatarStackContext
	
	init(
		avatars: [CutoutAvatarData],
		style: CutoutAvatarStyle,
		shouldCutout: Bool,
		showBorder: Bool
	) {
		_context = State(
			initialValue: CutoutAvatarStackContext(
				avatars: avatars,
				style: style,
				shouldCutout: shouldCutout,
				showBorder: showBorder
			)
		)
	}
	
	var body: some View {
		GeometryReader { geo in
			CutoutAvatarStackContent()
				.environment(context)
				.onAppear {
					context.updateContainerHeight(geo.size.height)
					context.triggerEntrance()
				}
				.onChange(of: geo.size.height) { _, newValue in
					context.updateContainerHeight(newValue)
				}
		}
		.frame(width: context.layout.totalWidth, alignment: .leading)
	}
}
