import SwiftUI

// MARK: - Root Host
struct DragResizableSheetLauncherView: View {
	private let sheetController = AppSheetController()
	@State private var screenHeight: CGFloat = 0

	var body: some View {
		VStack(spacing: 24) {
			Text("App Root")
				.font(.largeTitle)

			Button("Present Sheet") {
				sheetController.present()
			}
		}
		.background(
			WindowReader { screen in
				screenHeight = screen.bounds.height
				sheetController.updateScreenHeight(screen.bounds.height)
			}
		)
		.sheet(isPresented: sheetController.isPresentedBinding) {
			DragResizableSheetRootView(
				controller: sheetController
			)
		}
	}
}

// MARK: - Sheet Root (Level 1)
struct DragResizableSheetRootView: View {
	@State private var windowHeight: CGFloat = 0
	let controller: AppSheetController

	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				NavigationLink("Go to Level Two") {
					DragResizableSheetDetailView(
						setHeight: controller.setHeight,
						setMedium: { controller.snapToMedium() },
						setLarge: { controller.snapToLarge() },
						dismiss: controller.dismiss
					)
				}

				Button("Snap to Medium") {
					controller.snapToMedium()
				}

				Button("Expand to Large") {
					controller.snapToLarge()
				}

				Spacer()
			}
			.padding()
			.navigationTitle("Level One")
			.toolbarTitleDisplayMode(.inlineLarge)
		}
		.background(
			GeometryReader { proxy in
				Color.white
					.onAppear {
						windowHeight = proxy.size.height
					}
					.ignoresSafeArea()
			}
		)
		.modifier(SetSheetHeight(height: controller.sheetHeight, screenHeight: controller.screenHeight))
		.onAppear {
			if controller.sheetHeight == 0 {
				DispatchQueue.main.async {
					controller.primeInitialHeight()
				}
			}
		}
	}
}

// MARK: - Sheet Level 2 (CTA Owns Heights)
struct DragResizableSheetDetailView: View {
	let setHeight: (CGFloat) -> Void
	let setMedium: () -> Void
	let setLarge: () -> Void
	let dismiss: () -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Button("Compact – 400pt") {
				setHeight(400)
			}

			Button("Payment Review – 460pt") {
				setHeight(460)
			}

			Button("Confirmation – 580pt") {
				setHeight(580)
			}

			Divider()

			Button("Snap to Medium") {
				setMedium()
			}

			Button("Expand to Large") {
				setLarge()
			}

			Divider()

			Spacer()
		}
		.padding()
		.navigationTitle("Level 2 : Controls")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: dismiss) {
					Image(systemName: "xmark")
				}
				.buttonStyle(.plain)
			}

			ToolbarItem(placement: .topBarLeading) {
				AvatarStackView(circleSize: 42, shouldCutout: false)
			}
		}
	}
}

#Preview {
	DragResizableSheetLauncherView()
}
