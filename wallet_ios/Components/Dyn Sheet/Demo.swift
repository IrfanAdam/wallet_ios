import SwiftUI

struct PeripheralLaunchSurface: View {
	@State private var isAuxiliaryPlanePresented = false
	@State private var sheetState = AuxiliarySheetState(
		route: .levelOne
	)
	@State private var routeState = AuxiliaryContentState(
		route: .levelOne
	)
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: sheetState)
	}

	var body: some View {
		VStack(spacing: 24) {
			Text("Primary Interaction Surface")
				.font(.title2)

			Button("Invoke Secondary Plane") {
				isAuxiliaryPlanePresented.toggle()
			}
		}
		.padding()
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			SheetShell() {
				AuxiliarySheetRouter.routedContent(
					route: sheetState.route
				)
			} toolbar: {
				AuxiliaryToolbar(
					route: sheetState.route,
					onDismiss: { isAuxiliaryPlanePresented = false },
					onBack: coordinator.navigateBack
				)
			}
			.environment(sheetState)
			.environment(routeState)
		}
	}
}

#Preview { PeripheralLaunchSurface() }
