import SwiftUI

struct ToolbarMorphDemo: View {
	@State private var showAlt = false
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				if showAlt {
					Text("Alternate Content")
						.font(.largeTitle).transition(.blurReplace)
				} else {
					Text("Main Content")
						.font(.largeTitle).transition(.blurReplace)
				}
				
				Button("Toggle View") {
					withAnimation(.easeInOut(duration: 0.4)) {
						showAlt.toggle()
					}
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.navigationTitle(showAlt ? "Details" : "Home")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if showAlt {
					alternateToolbar
				} else {
					mainToolbar
				}
			}
		}
	}
	
	// MARK: - Toolbars
	
	@ToolbarContentBuilder
	var mainToolbar: some ToolbarContent {
		
		ToolbarItem(placement: .topBarTrailing) {
			Image(systemName: "gear")
		}
	}
	
	@ToolbarContentBuilder
	var alternateToolbar: some ToolbarContent {
		
		ToolbarItem(placement: .topBarLeading) {
			Image(systemName: "ellipsis.circle")
		}
		ToolbarItem(placement: .topBarLeading) {
			Image(systemName: "magnifyingglass")
		}
		
		ToolbarItem(placement: .topBarTrailing) {
			Image(systemName: "star.fill")
		}
	}
}

#Preview {
	ToolbarMorphDemo()
}
