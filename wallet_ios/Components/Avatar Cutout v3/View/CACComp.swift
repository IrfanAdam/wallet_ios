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
//		.if(context.animation.isRasterized) { $0.drawingGroup() }
		.drawingGroup()
		.frame(
			width: context.layout.totalWidth,
			alignment: .leading
		)
		.fixedSize(horizontal: true, vertical: false)
		.background(
			CutoutAvatarStackBackground()
				.environment(context)
		)
	}
}

// MARK: - Conditional Modifier Helper
private extension View {
	@ViewBuilder
	func `if`<Content: View>(
		_ condition: Bool,
		transform: (Self) -> Content
	) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}

