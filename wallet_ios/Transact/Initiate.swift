import SwiftUI

struct transactOpts: View {
	@State private var searchText = ""
	@State private var isSearchActive = false
	@Environment(\.dismiss) private var dismiss
	@State private var sheetDetent: PresentationDetent = .medium

	var body: some View {
		NavigationStack {
			ZStack {
				PseudoCameraView(videoName: "pay_mock")
					.id("backgroundVideo") // Stable identity
					.ignoresSafeArea()
					.overlay(
						Color.black.opacity(0.24)
					)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
				}
			}
			.toolbarVisibility(sheetDetent == .large ? .hidden : .visible)
		}
		.sheet(isPresented: .constant(true)) {
			TransactOptions(currentDetent: $sheetDetent)
				.presentationDetents([.medium, .large], selection: $sheetDetent)
				.presentationBackgroundInteraction(.enabled(upThrough: .large))
				.presentationDragIndicator(.visible)
				.interactiveDismissDisabled(true)
				.presentationBackground(Color(red: 250/255, green: 248/255, blue: 245/255))
		}
	}
}

#Preview {
	transactOpts()
}
