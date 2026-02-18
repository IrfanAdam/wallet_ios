import SwiftUI

struct ContextCapsuleStackModifier: ViewModifier {
	@Bindable var context: FullHeightCirclesContext
	
	func body(content: Content) -> some View {
		content
			.onAppear {
				context.resolveLayout()
			}
			.onChange(of: context.layout.circDia) { _, _ in
				context.resolveLayout() 
				context.spread()
			}
			.frame(width: context.stackWidth)
			.fixedSize(horizontal: true, vertical: false)
			.background(
				Capsule()
					.fill(context.model.style.stackBackgroundColor)
					.overlay {
						Capsule()
							.strokeBorder (
								context.model.style.strokeColor,
								lineWidth: context.model.style.strokeWidth
							)
					}
			)
			.clipShape(Capsule())
	}
}
