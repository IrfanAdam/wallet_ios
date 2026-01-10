import SwiftUI

// MARK: - Root View

struct PeripheralLaunchSurface: View {

	// MARK: - Presentation State

	@State private var isAuxiliaryPlanePresented = false
	@State private var route: AuxiliaryRoute = .levelOne

	// MARK: - Sheet State

	@State private var geometryController =
	SheetGeometryController(
		heightVariants: [
			.init(id: "A", height: 140),
			.init(id: "B", height: 320),
			.init(id: "C", height: 720)
		],
		activeIndex: 1,
		activeDetent: .height(240),
		sheetMetrics: SheetMetrics()
	)

	// MARK: - Body

	var body: some View {
		primarySurface
			.sheet(isPresented: $isAuxiliaryPlanePresented) {
				auxiliarySheet
			}
	}
}

// MARK: - Primary Surface

private extension PeripheralLaunchSurface {

	var primarySurface: some View {
		VStack(spacing: 24) {
			Text("Primary Interaction Surface")
				.font(.title2)

			Button("Invoke Secondary Plane") {
				isAuxiliaryPlanePresented.toggle()
			}
		}
		.padding()
	}
}

// MARK: - Auxiliary Sheet

private extension PeripheralLaunchSurface {
	var auxiliarySheet: some View {
		NavigationStack {
			GeometryReader { proxy in
				let geometry = SheetGeometry(
					size: proxy.size,
					safeAreaInsets: proxy.safeAreaInsets
				)

				ZStack {
					auxiliaryContent(using: geometry)
				}
				.animation(.easeInOut(duration: 0.35), value: route)
				.environment(geometryController.sheetMetrics)
			}
			.toolbar { auxiliaryToolbar }
		}
		.presentationDetents(detents, selection: $geometryController.activeDetent)
		.presentationBackground(.white)
		.presentationDragIndicator(.hidden)
	}

	var detents: Set<PresentationDetent> {
		Set(geometryController.heightVariants.map { .height($0.height) } + [.large])
	}
}

// MARK: - Route → Content Switching
private extension PeripheralLaunchSurface {
	@ViewBuilder
	func auxiliaryContent(using geometry: SheetGeometry) -> some View {
		switch route {
		case .levelOne:
			AuxiliaryPresentationPlane(
				heightVariants: $geometryController.heightVariants,
				activeIndex: $geometryController.activeIndex,
				activeDetent: $geometryController.activeDetent,
				route: $route,
				sheetGeometry: geometry
			)
			.transition(.blurReplace)

		case .levelTwo:
			LevelTwoView(
				heightVariants: $geometryController.heightVariants,
				activeIndex: $geometryController.activeIndex,
				activeDetent: $geometryController.activeDetent,
				route: $route,
				sheetGeometry: geometry
			)
			.transition(.blurReplace)
		}
	}
}

// MARK: - Toolbar & Detents
private extension PeripheralLaunchSurface {

	var auxiliaryToolbar: some ToolbarContent {
		AuxiliaryToolbar(
			route: route,
			onDismiss: dismissSheet,
			onBack: navigateBack
		)
	}
}

// MARK: - Intent Handlers

private extension PeripheralLaunchSurface {
	func dismissSheet() {
		isAuxiliaryPlanePresented = false
	}

	func navigateBack() {
		withAnimation(.easeInOut(duration: 0.35)) {
			route = .levelOne
		}
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
