import SwiftUI

struct AuxiliarySheetHost<Content: View>: View {
	@Environment(AuxiliarySheetState.self)
	private var state
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: state)
	}
	let onDismiss: () -> Void
	
	@ViewBuilder let content: () -> Content
	var body: some View {
		NavigationStack {
			GeometryReader { proxy in
				ZStack {
					content()
				}
				.onAppear { coordinator.syncGeometry(proxy) }
				.onChange(of: proxy.size) { coordinator.syncGeometry(proxy) }
				.animation(.easeInOut(duration: 0.35), value: state.route)
				.animation(.easeInOut(duration: 0.35), value: state.heightVariants)
			}
			.toolbar {
				AuxiliaryToolbar(
					route: state.route,
					onDismiss: onDismiss,
					onBack: coordinator.navigateBack
				)
			}
		}
		.presentationDetents(coordinator.detents, selection: Bindable(state).activeDetent)
		.presentationDragIndicator(.hidden)
		.presentationBackground(Color.white)
		.background(
			Rectangle()
				.fill(.white)
				.frame(width: state.geometry?.size.width, height: ScreenMetrics.screenSize.height * 2)
				.ignoresSafeArea()
		)
	}
}
