import SwiftUI

// MARK: - Entry Point

struct DragResizableSheetLauncherView: View {
	@State private var isSheetVisible = false
	
	var body: some View {
		Button("Present Drag-Resizable Sheet") {
			isSheetVisible = true
		}
		.sheet(isPresented: $isSheetVisible) {
			DragResizableSheetRootView(
				dismissSheet: {
					isSheetVisible = false
				}
			)
		}
	}
}

// MARK: - Sheet Root (Level 1)

struct DragResizableSheetRootView: View {
	let dismissSheet: () -> Void
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				Text("Sheet Level One")
					.font(.title)
				
				NavigationLink("Go to Level Two") {
					DragResizableSheetDetailView(
						dismissSheet: dismissSheet
					)
				}
			}
			.padding()
			.navigationTitle("Level One")
		}
		.presentationDetents([.medium, .large]) // user drags freely
		.presentationDragIndicator(.visible)
	}
}

// MARK: - Sheet Level 2

struct DragResizableSheetDetailView: View {
	let dismissSheet: () -> Void
	
	var body: some View {
		VStack(spacing: 24) {
			Text("Sheet Level Two")
				.font(.title)
			
			Text("You can still drag the sheet between Medium and Large.")
				.multilineTextAlignment(.center)
		}
		.padding()
		.navigationTitle("Level Two")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Close") {
					dismissSheet() // ALWAYS dismisses the sheet
				}
			}
		}
	}
}

// MARK: - Preview

#Preview {
	DragResizableSheetLauncherView()
}
