import SwiftUI

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented = false
	@State private var sheetState = AuxiliarySheetState(
		heightVariants: [
			.init(id: "A", height: 140),
			.init(id: "B", height: 320),
			.init(id: "C", height: 720)
		],
		activeIndex: 1,
		activeDetent: .height(240),
		route: .levelOne
	)
	@State private var routeState = AuxiliaryContentState(
		route: .levelOne
	)

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
			AuxiliarySheetHost(
				onDismiss: { isAuxiliaryPlanePresented = false }
			)
			.environment(sheetState)
			.environment(routeState)
		}
	}
}

#Preview { PeripheralLaunchSurface() }
