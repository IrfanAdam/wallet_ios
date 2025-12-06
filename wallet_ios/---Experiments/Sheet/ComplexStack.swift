import SwiftUI

struct BottomToPageDemo: View {
	@State private var showBottomSheet = false

	var body: some View {
		VStack(spacing: 20) {
			Button("Open Bottom Sheet") {
				showBottomSheet = true
			}
			Spacer()
			Button("Open Bottom Sheet") {
				showBottomSheet = true
			}
		}
		.sheet(isPresented: $showBottomSheet) {
			BottomSheetLevel()
				.presentationDetents([.medium, .large])
				.presentationDragIndicator(.visible)
				.presentationBackgroundInteraction(.enabled)
		}
	}
}

struct BottomSheetLevel: View {
    @State private var showPageSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Bottom Sheet")
                .font(.title2)

            Text("Drag up to expand to full screen")

            Button("Open Page Sheet") {
                showPageSheet = true
            }
        }
        .padding()
        // Nested page sheet triggers only after sheet is large
        .sheet(isPresented: $showPageSheet) {
            NestedPageLevel()
                .presentationSizing(.page)
                .presentationDragIndicator(.visible)
        }
    }
}

struct NestedPageLevel: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Page Sheet Level")
                .font(.title)
            Text("This is now a full-page style sheet. You can stack more pages here.")
        }
        .padding()
    }
}


#Preview {
    BottomToPageDemo()
}
