import SwiftUI

// MARK: - Main View
struct InitiatePayment: View {
	var namespace: Namespace.ID

	@State private var context = InitiatePaymentContext()
	@Environment(\.dismiss) private var dismiss
	@Environment(\.sheetControl) private var sheetControl

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
				FlowRenderer(items: [
					.text("Jabari M. Last Name", .primary),
					.text("will send", .secondary),
					.text("CFA 1500", .primary),
					.pill("Daily"),
					.text("for Groceries", .secondary),
					.pill("Category"),
				])
				.padding()

				AmountInputView(context: context, flag: flag(for:))
					.padding(.horizontal)

				ContentPhaseContainer(context: $context)

				Spacer()
			}
			.background(Color.clear)
			.navigationBarBackButtonHidden(true)
			.toolbar {
				InitiatePaymentToolbar(
					dismiss: dismiss,
					sheetControl: sheetControl
				)
			}
		}
		.safeAreaInset(edge: .bottom) {
			BottomActionAreaView(
				context: context,
				namespace: namespace,
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
