import SwiftUI

struct transactOpts: View {
	@State private var searchText = ""
	@State private var isSearchActive = false
	@Environment(\.dismiss) private var dismiss
	var body: some View {
		NavigationStack {
			List {
				Text("Start typing to scan…")
			}
			.navigationTitle("Pay")
			.searchable(text: $searchText, isPresented: $isSearchActive)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
				}
			}
		}
	}
}

#Preview {
	transactOpts()
}
