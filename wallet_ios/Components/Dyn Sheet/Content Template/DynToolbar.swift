import SwiftUI

struct AuxiliaryToolbar: ToolbarContent {
	let route: AuxiliaryRoute
	let onDismiss: () -> Void
	let onBack: () -> Void
	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {leading}
		ToolbarItem(placement: .topBarTrailing) {trailing}
	}
}

private extension AuxiliaryToolbar {
	@ViewBuilder
	var leading: some View {
		if route == .levelTwo {
//			Button(action: onBack) {
//				AvatarStackView(
//					avatars: [
//						AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
//						AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
//					],
//					circleSize: 42,
//					shouldCutout: false
//				)
//			}
			MeasuredLeadingAvatar(onBack: onBack)
			.padding(.horizontal, -7.5)

		} else if route == .levelOne {
			Button(action: onDismiss) {
				Label("Dismiss", systemImage: "chevron.down")
			}
		}
	}
	
	@ViewBuilder
	var trailing: some View {
		if route == .levelTwo {
			Button(action: onDismiss) {
				Image(systemName: "xmark")
			}
			.buttonStyle(.plain)
		}
	}
}

private struct MeasuredLeadingAvatar: View {
	let onBack: () -> Void

	@State private var height: CGFloat = 42
	@State private var locked = false

	private struct HeightKey: PreferenceKey {
		static var defaultValue: CGFloat = 0
		static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
			value = nextValue()
		}
	}

	var body: some View {
		Button(action: onBack) {
			AvatarStackView(
				avatars: [
					AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
					AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
				],
				circleSize: 42,
				shouldCutout: false
			)
		}
		.background(
			GeometryReader { geo in
				let h = geo.size.height
				Color.clear
				.onAppear {
					print("🟨 Geometry appear — reported height:", h)
				}
				.preference(
					key: HeightKey.self,
					value: geo.size.height
				)
			}
		)
		.onPreferenceChange(HeightKey.self) { h in
			guard !locked, h > 0 else { return }
			height = h
			locked = true
		}
		.onChange(of: height) {_, new in
			print("🟧 Geometry change — reported height:", new)
		}
	}
}
