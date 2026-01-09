import SwiftUI


struct PeripheralLaunchSurface: View {
	@State private var isAuxiliaryPlanePresented = false
	@State private var sheetMetrics = SheetMetrics()

//	@State private var heightVariants: [HeightVariant] = [
//		.init(id: "s", height: 140),
//		.init(id: "m", height: 320),
//		.init(id: "l", height: 720)
//	]
//
//	@State private var activeIndex: Int = 1
//	@State private var activeDetent: PresentationDetent = .height(240)

	@State private var route: AuxiliaryRoute = .levelOne

	@State private var detents = DetentController(
		heightVariants: [
			.init(id: "s", height: 140),
			.init(id: "m", height: 320),
			.init(id: "l", height: 720)
		],
		activeIndex: 1,
		activeDetent: .height(320)
	)

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 24) {
			primaryContent
		}
		.padding()
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			auxiliarySheet
		}
	}
}

private extension PeripheralLaunchSurface /*Launcher Body*/ {
	var primaryContent: some View {
		VStack(spacing: 24) {
			Text("Primary Interaction Surface")
				.font(.title2)

			Button("Invoke Secondary Plane") {
				isAuxiliaryPlanePresented.toggle()
			}
		}
	}
}

//SheetDeclare
private extension PeripheralLaunchSurface {
	var auxiliarySheet: some View {
		NavigationStack {
			GeometryReader { proxy in
				sheetContent(using: proxy)
			}
			.toolbar { auxiliaryToolbar }
		}
		.presentationDetents(
			Set(detents.heightVariants.map { .height($0.height) } + [.large]),
			selection: $detents.activeDetent
		)
		.presentationBackground(.white)
		.presentationDragIndicator(.hidden)
	}
}

//SheetContent
private extension PeripheralLaunchSurface {
	func sheetContent(using proxy: GeometryProxy) -> some View {
		let geometry = SheetGeometry(
			size: proxy.size,
			safeAreaInsets: proxy.safeAreaInsets
		)

		return ZStack {
			routedContent(geometry: geometry)
		}
		.animation(.easeInOut(duration: 0.35), value: route)
		.environment(sheetMetrics)
		.environment(detents)
	}
}

//Content Switch
private extension PeripheralLaunchSurface {
	@ViewBuilder
	func routedContent(geometry: SheetGeometry) -> some View {
		switch route {
		case .levelOne:
			AuxiliaryPresentationPlane(
				route: $route,
				sheetGeometry: geometry
			)

		case .levelTwo:
			LevelTwoView(
				route: $route,
				sheetGeometry: geometry
			)
		}
	}
}

//Toolbar
private extension PeripheralLaunchSurface {
	var auxiliaryToolbar: some ToolbarContent {
		AuxiliaryToolbar(
			route: route,
			onDismiss: {
				isAuxiliaryPlanePresented = false
			},
			onBack: {
				withAnimation(.easeInOut(duration: 0.35)) {
					route = .levelOne
				}
			}
		)
	}
}

#Preview {
	PeripheralLaunchSurface()
}
