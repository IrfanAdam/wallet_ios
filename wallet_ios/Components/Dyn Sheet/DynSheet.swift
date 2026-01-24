import SwiftUI

struct AuxiliarySheetHost: View {

	@Environment(AuxiliarySheetState.self)
	private var state
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: state)
	}

	let onDismiss: () -> Void

	var body: some View {
		NavigationStack {
			GeometryReader { proxy in
				ZStack {
					AuxiliarySheetBuilders.routedContent(route: state.route)
				}
				.onAppear { coordinator.syncGeometry(proxy) }
				.onChange(of: proxy.size) { coordinator.syncGeometry(proxy) }
				.animation(.easeInOut(duration: 0.35), value: state.route)
				.animation(.easeInOut(duration: 0.35), value: state.heightVariants)
			}
			.toolbar { AuxiliarySheetBuilders.toolbar(route: state.route, onDismiss: onDismiss, onBack: coordinator.navigateBack) }
		}
		.presentationDetents(coordinator.detents, selection: Bindable(state).activeDetent)
		.presentationDragIndicator(.hidden)
		.background(
			Rectangle().fill(.white).frame(width: .infinity, height: 1000)
		)
	}
}

