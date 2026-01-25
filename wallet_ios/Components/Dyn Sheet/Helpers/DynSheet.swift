import SwiftUI

struct AuxiliarySheetHost<
	Content: View,
	Toolbar: ToolbarContent
>: View {
	@Environment(AuxiliarySheetState.self)
	private var state
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: state)
	}
	
	@ViewBuilder let content: () -> Content
	@ToolbarContentBuilder let toolbar: () -> Toolbar
	
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
				toolbar()
			}
		}
		.presentationDetents(coordinator.detents, selection: Bindable(state).activeDetent)
		.presentationDragIndicator(.hidden)
		.presentationDragIndicator(.hidden)
		.presentationBackground(Color.white)
		.highPriorityGesture(DragGesture())
		.background(
			Rectangle()
				.fill(Color(red: 250/255, green: 248/255, blue: 245/255))
				.frame(width: state.geometry?.size.width, height: ScreenMetrics.screenSize.height * 2)
				.ignoresSafeArea()
		)
	}
}
