import SwiftUI

struct InitiatePayment: View {
	var namespace: Namespace.ID
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss
	@Environment(\.sheetControl) private var sheetControl
	
	@State private var amountValue: String = ""
	@State private var hasContinued: Bool = false
	@State private var isAuthenticating: Bool = false
	
	
	@State private var integerPart: String = ""
	@State private var decimalPart: String = ""
	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool
	@State private var selectedCurrency = "INR"
	
	@State private var note: String = ""
	@State private var selectedTags: [PaymentTag] = [.remittance]
	
	// MARK: - Animations
	private let instantSpring = Animation.spring(response: 0.2, dampingFraction: 0.95, blendDuration: 0)
	private let snappySpring = Animation.spring(response: 0.25, dampingFraction: 0.92, blendDuration: 0)
	private let smoothSpring = Animation.spring(response: 0.3, dampingFraction: 0.88, blendDuration: 0)
	
	var fullAmount: String {
		decimalPart.isEmpty ? integerPart : "\(integerPart).\(decimalPart)"
	}
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 12) {
				SimpleFlowWrap( items: paymentFlowItems ).padding(.horizontal)
				
				// --- Command: Amount input + currency selection
				AmountInputView(
					integerPart: $integerPart,
					decimalPart: $decimalPart,
					focusInteger: _focusInteger,
					focusDecimal: _focusDecimal,
					selectedCurrency: $selectedCurrency,
					flag: flag(for:)
				).padding(.horizontal)
				
				if hasContinued {
					PaymentTagSection(
						note: $note,
						selectedTags: $selectedTags
					)
					.padding(.horizontal)
					.transition(.move(edge: .bottom).combined(with: .opacity))
				} else {
					Divider().padding(.horizontal)
				}
				
				Spacer()
		
			}
			.background(Color.clear)
			.navigationBarBackButtonHidden(true)
			.toolbar { toolbarContent }
		}
		.onAppear { sheetControl.setDetent(.medium) }
		.safeAreaInset(edge: .bottom) {
			// --- Command: Bottom action area
			BottomActionAreaView(
				isAuthenticating: $isAuthenticating,
				hasContinued: $hasContinued,
				namespace: namespace,
				fullAmount: fullAmount,
				selectedCurrency: selectedCurrency,
				instantSpring: instantSpring,
				snappySpring: snappySpring,
				smoothSpring: smoothSpring
			)
			.padding(0)
		}
	}
	
	// MARK: - Helper
	private func flag(for currency: String) -> String {
		switch currency {
		case "INR": return "🇮🇳"
		case "USD": return "🇺🇸"
		case "EUR": return "🇪🇺"
		default: return "🏳️"
		}
	}
	
	// MARK: - Payment flow items
	private var paymentFlowItems: [AnyView] {
		renderFlowItems([ .text("Jabari M. Last Name", tone: .primary), ])
	}
	
	// MARK: - Toolbar
	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			AvatarStackView()
				.onTapGesture { dismiss() }
		}
		ToolbarSpacer(.flexible)
		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") { sheetControl.dismiss() }
		}
	}
}

#Preview {
	PreviewContainer()
}

private struct PreviewContainer: View {
	@Namespace var ns
	var body: some View {
		InitiatePayment(namespace: ns)
			.background(Color.black.ignoresSafeArea())
	}
}
