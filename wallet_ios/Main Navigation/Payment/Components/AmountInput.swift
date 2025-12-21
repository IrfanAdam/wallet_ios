import SwiftUI

struct AmountInputView: View {
	@Binding var integerPart: String
	@Binding var decimalPart: String
	@FocusState var focusInteger: Bool
	@FocusState var focusDecimal: Bool
	@Binding var selectedCurrency: String
	var flag: (String) -> String
	
	var body: some View {
		HStack(alignment: .bottom) {
			CurrencyTwoFieldDemo()
			Spacer()
			Menu {
				CurrencySelectionButton(code: "INR", name: "Indian Rupee", selectedCurrency: $selectedCurrency)
				CurrencySelectionButton(code: "USD", name: "US Dollar", selectedCurrency: $selectedCurrency)
				CurrencySelectionButton(code: "EUR", name: "Euro", selectedCurrency: $selectedCurrency)
			} label: {
				HStack(spacing: 4) {
					Text(flag(selectedCurrency)).font(.title2)
					Text(selectedCurrency).font(.body.weight(.medium))
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
