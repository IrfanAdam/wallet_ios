import SwiftUI

// MARK: - Payment Context
@Observable
final class InitiatePaymentContext {
	// Amount
	var integerPart: String = ""
	var decimalPart: String = ""
	var selectedCurrency: String = "INR"

	// UI flow
	var showTags: Bool = false
	var hasContinued: Bool = false
	var isAuthenticating: Bool = false

	// Tags & note
	var note: String = ""
	var selectedTags: [PaymentTag] = [.remittance]

	// Toolbar
//	var toolbarHeight: CGFloat = 0

	// Derived
	var fullAmount: String {
		decimalPart.isEmpty ? integerPart : "\(integerPart).\(decimalPart)"
	}
}

// MARK: - Main View
struct InitiatePayment: View {
	var namespace: Namespace.ID

	@State private var context = InitiatePaymentContext()
	@Environment(\.dismiss) private var dismiss
	@Environment(\.sheetControl) private var sheetControl

	// MARK: - Animations
	private let instantSpring = Animation.spring(response: 0.2, dampingFraction: 0.95)
	private let snappySpring = Animation.spring(response: 0.25, dampingFraction: 0.92)
	private let smoothSpring = Animation.spring(response: 0.3, dampingFraction: 0.88)

	// MARK: - Content Phase
	enum ContentPhase: Equatable {
		case amount
		case tags
	}

	private var contentPhase: ContentPhase {
		context.showTags ? .tags : .amount
	}

	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 12) {
				SimpleFlowWrap(items: paymentFlowItems)
					.padding(.horizontal)

				// Amount Input + Currency Selection
				AmountInputView(context: context, flag: flag(for:))
					.padding(.horizontal)

				// Dynamic Content Phase Container
				ContentPhaseContainer(context: $context)

				Spacer()
			}
			.background(Color.clear)
			.navigationBarBackButtonHidden(true)
			.toolbar { toolbarContent }
		}
		.safeAreaInset(edge: .bottom) {
			BottomActionAreaView(
				context: context,
				namespace: namespace,
				instantSpring: instantSpring,
				snappySpring: snappySpring,
				smoothSpring: smoothSpring
			)
		}
		.task {
			sheetControl.setDetent(.medium)
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

	// MARK: - Payment Flow Items
	private var paymentFlowItems: [AnyView] {
		renderFlowItems([.text("Jabari M. Last Name", tone: .primary)])
	}
	
	// MARK: - Toolbar (Optimized)
	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItemGroup(placement: .topBarLeading) {
			ToolbarLeadingContent(
				dismiss: dismiss
			)
		}
		ToolbarSpacer(.flexible)
		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") {
				sheetControl.dismiss()
			}
		}
	}
}

// MARK: - Toolbar Leading Content (Separate View)
private struct ToolbarLeadingContent: View {
	let dismiss: DismissAction
	
	@State private var hasSetHeight = false
	
	var body: some View {
		ToolbarPill {
			AvatarStackView(
				avatars: [
					AvatarData(content: .image(Image("LargeDP")), hasBorder: false),
					AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
				],
				shouldCutout: true
			)
		}
		.padding(.horizontal, 1.5)
		.padding(.vertical, 1.5)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onTapGesture { dismiss() }
	}
}

// MARK: - Dynamic ContentPhase Container
struct ContentPhaseContainer: View {
	@Binding var context: InitiatePaymentContext

	var body: some View {
		VStack(spacing: 0) {
			switch context.showTags {
			case false:
				Divider()
					.padding(.horizontal)
			case true:
				PaymentTagSection(
					note: $context.note,
					selectedTags: $context.selectedTags
				)
				.padding(.horizontal)
			}
		}
	}
}

// MARK: - Preview
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
