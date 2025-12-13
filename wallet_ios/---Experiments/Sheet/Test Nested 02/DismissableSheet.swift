import SwiftUI

// MARK: - Environment Key

private struct SheetDismissActionKey: EnvironmentKey {
	static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
	var dismissSheet: () -> Void {
		get { self[SheetDismissActionKey.self] }
		set { self[SheetDismissActionKey.self] = newValue }
	}
}

// MARK: - App Entry View

struct EnvironmentDismissDemo: View {
	@State private var showSheet = false
	
	var body: some View {
		Button("Open Search Sheet") {
			showSheet = true
		}
		.sheet(isPresented: $showSheet) {
			NavigationStack {
				SearchRootView()
			}.environment(\.dismissSheet) {
				showSheet = false
			}
		}
		.padding()
	}
}

// MARK: - Sheet Root

struct SearchRootView: View {
	var body: some View {
		VStack(spacing: 24) {
			Text("Search Results")
				.font(.title)
			
			NavigationLink("Go to Payment") {
				InitiatePaymentView()
			}
		}
		.navigationTitle("Search")
		.padding()
	}
}

// MARK: - Deep Child View

struct InitiatePaymentView: View {
	@Environment(\.dismissSheet) private var dismissSheet
	@Environment(\.dismiss) private var dismissNavigation
	
	var body: some View {
		VStack(spacing: 24) {
			Text("Payment Screen")
				.font(.title)
			
			Button("Close Sheet (from deep view)") {
				dismissSheet()
			}
			
			Button("Back Only") {
				dismissNavigation()
			}
		}
		.navigationTitle("Payment")
		.padding()
	}
}

// MARK: - Preview

#Preview {
	EnvironmentDismissDemo()
}
