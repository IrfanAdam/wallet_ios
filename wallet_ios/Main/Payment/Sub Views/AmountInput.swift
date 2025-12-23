import SwiftUI

struct AmountInputView: View {
	@Bindable var context: InitiatePaymentContext

	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool

	var flag: (String) -> String

	var body: some View {
		HStack(alignment: .bottom) {
			CurrencyTwoFieldDemo()

			Spacer()

			Menu {
				CurrencySelectionButton(
					code: "INR",
					name: "Indian Rupee",
					selectedCurrency: $context.selectedCurrency
				)
				CurrencySelectionButton(
					code: "USD",
					name: "US Dollar",
					selectedCurrency: $context.selectedCurrency
				)
				CurrencySelectionButton(
					code: "EUR",
					name: "Euro",
					selectedCurrency: $context.selectedCurrency
				)
			} label: {
				HStack(spacing: 4) {
					Text(flag(context.selectedCurrency))
						.font(.title2)
					Text(context.selectedCurrency)
						.font(.body.weight(.medium))
				}
				.buttonStyle(.plain)
				.padding(.horizontal, 8)
				.padding(.vertical, 4)
				.background(.thinMaterial)
				.clipShape(Capsule())
			}
		}
	}

}

private struct CurrencySelectionButton: View {
	let code: String
	let name: String
	@Binding var selectedCurrency: String
	
	var body: some View {
		Button {
			selectedCurrency = code
		} label: {
			HStack {
				Text("\(code) – \(name)")
				Spacer()
				if selectedCurrency == code { Image(systemName: "checkmark") }
			}
		}
	}
}
