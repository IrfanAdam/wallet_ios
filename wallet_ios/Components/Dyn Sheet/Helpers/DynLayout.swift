import SwiftUI

//Used to update the current sheet size  in shared state
struct AuxiliarySheetLayout {
	let state: AuxiliarySheetState
	
	var detents: Set<PresentationDetent> {
		Set(state.heightVariants.map { .height($0.height) } + [.large])
	}
	
	func syncGeometry(_ proxy: GeometryProxy) {
		state.geometry = SheetGeometry(
			size: proxy.size,
			safeAreaInsets: proxy.safeAreaInsets
		)
	}
	
	static func contentHeight(
		proxy: GeometryProxy,
		geometry: SheetGeometry?
	) -> CGFloat {
		guard let geometry else { return 0 }
		
		return proxy.size.height
		+ geometry.safeAreaInsets.top
		+ geometry.safeAreaInsets.bottom
	}
	
	static func resizeToContent(
		_ newHeight: CGFloat,
		state: AuxiliarySheetState
	) {
		guard newHeight > 0 else { return }
		
		let nextIndex = (state.activeIndex + 1) % state.heightVariants.count
		
		withAnimation(.easeInOut(duration: 0.35)) {
			state.heightVariants[nextIndex].height = newHeight
			state.activeIndex = nextIndex
			state.activeDetent = .height(newHeight)
		}
	}
	
	struct PlaneMeasurementLayer: View {
		let state: AuxiliarySheetState
		let updHeight: (CGFloat) -> Void
		
		var body: some View {
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						updNewHeight(proxy)
					}
					.onChange(of: state.geometry) {
						updNewHeight(proxy)
					}
			}
		}
		
		private func updNewHeight(_ proxy: GeometryProxy) {
			let height = AuxiliarySheetLayout.contentHeight(
				proxy: proxy,
				geometry: state.geometry
			)
			updHeight(height)
		}
	}
}

enum ScreenMetrics {
	static var screenSize: CGSize {
		guard
			let scene = UIApplication.shared.connectedScenes
				.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
		else {
			return .zero
		}
		
		return scene.screen.bounds.size
	}
}
