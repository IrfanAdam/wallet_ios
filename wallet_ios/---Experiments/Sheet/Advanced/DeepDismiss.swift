import SwiftUI

// MARK: - Root Host

struct DragResizableSheetLauncherView: View {

	private let sheetController = AppSheetController()

	@State private var renderTick: Int = 0

	var body: some View {
		let _ = renderTick

		VStack(spacing: 24) {
			Text("App Root")
				.font(.largeTitle)

			Button("Present Sheet") {
				sheetController.present()
			}
		}
		.onAppear {
			sheetController.bind {
				renderTick &+= 1
			}
		}
		.sheet(isPresented: sheetController.isPresentedBinding) {
			DragResizableSheetRootView(
				detents: sheetController.availableDetents,
				selection: sheetController.detentSelectionBinding,
				setDetent: sheetController.setDetent,
				dismiss: sheetController.dismiss
			)
		}
	}
}

// MARK: - Sheet Root (Level 1)

struct DragResizableSheetRootView: View {

	let detents: [PresentationDetent]
	let selection: Binding<PresentationDetent>
	let setDetent: (PresentationDetent) -> Void
	let dismiss: () -> Void

	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				Text("Sheet Level One")
					.font(.title)

				NavigationLink("Go to Level Two") {
					DragResizableSheetDetailView(
						setHeight: { height in
							setDetent(.height(height))
						},
						setMedium: {
							setDetent(.medium)
						},
						setLarge: {
							setDetent(.large)
						},
						dismiss: dismiss
					)
				}
			}
			.padding()
			.navigationTitle("Level One")
		}
		// 🔑 FIX: Convert Array → Set here
		.presentationDetents(Set(detents), selection: selection)
		.presentationDragIndicator(.visible)
		.presentationBackground(Color.white)
	}
}

// MARK: - Sheet Level 2 (CTA Owns Heights)

struct DragResizableSheetDetailView: View {

	let setHeight: (CGFloat) -> Void
	let setMedium: () -> Void
	let setLarge: () -> Void
	let dismiss: () -> Void

	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {

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

			}
			.padding()
			.navigationTitle("Level 2 : Controls")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
					.buttonStyle(.plain)
				}
			}
		}
	}

}

// MARK: - Preview

#Preview {
	DragResizableSheetLauncherView()
}
