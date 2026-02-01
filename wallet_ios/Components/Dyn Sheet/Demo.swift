import SwiftUI

struct PeripheralLaunchSurface: View {
	@State private var isAuxiliaryPlanePresented = false
	@State private var sheetState = AuxiliarySheetState()
	@State private var contentState = AuxiliaryContentState(
		route: .levelOne
	)
	private var coordinator: AuxiliarySheetCoordinator {
		AuxiliarySheetCoordinator(state: contentState)
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
			SheetShell {
				AuxiliarySheetRouter.routedContent(
					route: contentState.route
				)
			} toolbar: {
				AuxiliaryToolbar(
					route: contentState.route,
					onDismiss: { isAuxiliaryPlanePresented = false },
					onBack: coordinator.navigateBack
				)
			}
			.environment(sheetState)
			.environment(contentState)
		}
	}
}

#Preview { PeripheralLaunchSurface() }
