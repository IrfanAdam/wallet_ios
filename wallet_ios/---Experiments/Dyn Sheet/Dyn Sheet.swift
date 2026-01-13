import SwiftUI

struct AuxiliarySheetHost: View {

	@Environment(AuxiliarySheetState.self)
	private var state

	let onDismiss: () -> Void

	var body: some View {
		NavigationStack {
			GeometryReader { proxy in
				ZStack {
					routedContent
				}
				.animation(.easeInOut(duration: 0.35), value: state.route)
				.onAppear { syncGeometry(proxy) }
				.onChange(of: proxy.size) { syncGeometry(proxy) }
			}
			.toolbar { toolbar }
		}
		.presentationDetents(detents, selection: Bindable(state).activeDetent)
		.presentationBackground(.white)
		.presentationDragIndicator(.hidden)
	}

	// MARK: Routed Content
	@ViewBuilder
	private var routedContent: some View {
		switch state.route {
		case .levelOne:
			LevelOneView()
				.transition(.blurReplace)

		case .levelTwo:
			LevelTwoView()
				.transition(.blurReplace)
		}
	}

	// MARK: Toolbar
	private var toolbar: some ToolbarContent {
		AuxiliaryToolbar( route: state.route, onDismiss: onDismiss, onBack: navigateBack )
	}

	private func navigateBack() {
		withAnimation(.easeInOut(duration: 0.35)) {
			state.route = .levelOne
		}
	}

	// MARK: Detents
	private var detents: Set<PresentationDetent> {
		Set(state.heightVariants.map { .height($0.height) } + [.large])
	}

	// MARK: Geometry
	private func syncGeometry(_ proxy: GeometryProxy) {
		state.geometry = SheetGeometry(
			size: proxy.size,
			safeAreaInsets: proxy.safeAreaInsets
		)
	}
}
