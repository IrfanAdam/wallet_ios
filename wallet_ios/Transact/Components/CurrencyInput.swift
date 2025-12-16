import SwiftUI

struct CurrencyInput: View {
	let placeholder: String
	@Binding var amount: String   // parent can read & write value
	var autoFocus: Bool = false   // 👈 pass intent
	@FocusState private var isFocused: Bool

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			// Top label
			Text(placeholder)
				.font(.subheadline)
				.foregroundStyle(.secondary)

			ZStack(alignment: .leading) {
				// Placeholder inside field
				if amount.isEmpty {
					Text(placeholder)
						.font(.custom("OpenRunde-Bold", size: 36))
						.foregroundStyle(
							Color(red: 0.11, green: 0.18, blue: 0.23)
								.opacity(0.35)
						)
						.kerning(-0.32)
				}

				TextField("", text: $amount)
					.keyboardType(.decimalPad)
					.textFieldStyle(.plain)
					.font(.custom("OpenRunde-Bold", size: 36))
					.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
					.kerning(-0.8)
					.focused($isFocused)
					.multilineTextAlignment(.leading)
					.onChange(of: amount) { _, newValue in
						let formatted = formatCurrencyInput(newValue)
						if formatted != newValue {
							amount = formatted
						}
					}
			}
			.onAppear {
				if autoFocus {
					// small delay avoids keyboard race conditions
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						isFocused = true
					}
				}
			}
		}
	}

	private func formatCurrencyInput(_ value: String) -> String {
		// Keep only digits + decimal
		let filtered = value.filter { "0123456789.".contains($0) }

		// Prevent multiple decimals
		let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)
		if parts.count > 2 {
			return String(parts[0]) + "." + parts[1]
		}

		return filtered
	}
}

#Preview {
	// State must be declared outside the closure
	PreviewField()
}

struct PreviewField: View {
	@State private var amountValue: String = ""

	var body: some View {
		VStack(alignment: .leading, spacing: 24) {
			Text("Payment")
				.font(.headline)
				.foregroundStyle(.secondary)

			CurrencyInput(placeholder: "Enter amount", amount: $amountValue)
				.frame(height: 44)

			Spacer()
		}
		.padding()
		.background(Color(.systemBackground))
	}
}
