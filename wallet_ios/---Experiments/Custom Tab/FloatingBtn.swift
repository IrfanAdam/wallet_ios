import SwiftUI

struct FABCheck: View {
	@State private var showScan = false
	var body: some View {
		NavigationStack {
			List(0..<32) { i in
				Text("Item \(i)")
			}
			.navigationTitle("Fab Check")
			.safeAreaInset(edge: .bottom, alignment: .trailing) {
				Button {
					showScan = true
				} label: {
					Image(systemName: "qrcode.viewfinder")
						.font(.title.weight(.semibold))
						.padding(.horizontal, 8)
						.padding(.vertical, 12)
				}
				.buttonStyle(.glassProminent)
				.padding(20)
				.tint(.blue.opacity(0.82))
			}
			.fullScreenCover(isPresented: $showScan) {
				transactOpts()
			}
		}
	}
}

#Preview {
	FABCheck()
}
