import SwiftUI

struct SheetShell<
	Content: View,
	Toolbar: ToolbarContent
>: View {
	@Environment(AuxiliarySheetState.self)
	private var state
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: state)
	}
	private var setLayout: AuxiliarySheetLayout {
		AuxiliarySheetLayout(state: state)
	}
	
	@ViewBuilder let sheetContent: () -> Content
	@ToolbarContentBuilder let toolbar: () -> Toolbar
	
	var body: some View {
		NavigationStack {
			GeometryReader { proxy in
				sheetContent()
					.onChange(of: proxy.size) { setLayout.syncGeometry(proxy) }
					.animation(.easeInOut(duration: 0.25), value: state.route)
					.animation(.easeInOut(duration: 0.35), value: state.heightVariants)
			}
			.toolbar {
				toolbar()
			}
		}
		.presentationDetents(setLayout.detents, selection: Bindable(state).activeDetent)
		.presentationDragIndicator(.hidden)
		.presentationBackground(Color.white)
		.highPriorityGesture(DragGesture())
		.background(
			Rectangle()
				.fill(Color(red: 250/255, green: 248/255, blue: 245/255))
				.frame(width: state.geometry?.size.width, height: ScreenMetrics.screenSize.height * 1.5)
				.ignoresSafeArea()
		)
	}
}
