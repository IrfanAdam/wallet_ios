import SwiftUI

struct ContextCapsuleStackModifier: ViewModifier {
	@Bindable var context: FullHeightCirclesContext
	
	func body(content: Content) -> some View {
		content
			.onAppear {
				context.spread()
				context.resolveLayout()
			}
			.onChange(of: context.layout.circDia) { _, _ in
				context.spread()
				context.resolveLayout()
			}
			.frame(width: context.stackWidth)
			.fixedSize(horizontal: true, vertical: false)
			.background(
				Capsule()
					.fill(Color.black)
			)
	}
}
