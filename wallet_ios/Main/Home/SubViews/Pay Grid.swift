import SwiftUI

struct PaymentActionsGrid: View {
	@Namespace private var morphNS
	@State private var activeSheet: SheetKind?
	
	let actions: [PaymentAction] = [
		PaymentAction(title: "Pay", icon: "arrow.up"),
		PaymentAction(title: "International", icon: "globe"),
		PaymentAction(title: "Request", icon: "arrow.down.to.line"),
		PaymentAction(title: "Withdraw", icon: "arrow.down.left.hand.draw"),
		PaymentAction(title: "Deposit", icon: "arrow.up.right.hand.draw"),
		PaymentAction(title: "Split", icon: "arrow.triangle.branch")
	]
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(actions) { action in
					PaymentActionCard(
						title: action.title,
						icon: action.icon
					) {
						activeSheet = .search
					}
					.frame(width: 140)
				}
			}
			.padding(.horizontal, 20)
		}
		.sheet(item: $activeSheet) { sheet in
			sheetView(for: sheet)
			// Provide dismiss closure to wrapper
				.environment(\.sheetControl, SheetControl(
					dismiss: { activeSheet = nil },
					setDetent: { _ in }
				))
		}
	}
	
	// MARK: - Sheet Content
	@ViewBuilder
	private func sheetView(for sheet: SheetKind) -> some View {
		switch sheet {
		case .search:
			SearchPageWrapper(namespace: morphNS)
		}
	}
}

// Wrapper to isolate detent state inside the sheet
private struct SearchPageWrapper: View {
	@State private var detent: PresentationDetent = .large
	@Environment(\.sheetControl) private var parentControl
	let namespace: Namespace.ID
	
	var body: some View {
		SearchPage(detent: $detent, namespace: namespace)
			.presentationDetents([.medium, .large], selection: $detent)
			.presentationDragIndicator(.visible)
			.presentationBackground(
				Color(red: 250/255, green: 248/255, blue: 245/255)
			)
		// Override only setDetent, keep parent's dismiss
			.environment(\.sheetControl, SheetControl(
				dismiss: parentControl.dismiss,
				setDetent: { newDetent in
					detent = newDetent
				}
			))
	}
}

// MARK: - Sheet Kind
private enum SheetKind: Identifiable {
	case search
	
	var id: String {
		switch self {
		case .search: return "search"
		}
	}
}
