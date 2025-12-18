import SwiftUI
import Foundation

struct CurrencyInput: View {
	let label: String
	let placeholder: String
	let showsLabel: Bool
	@Binding var amount: String   // parent can read & write value
	var autoFocus: Bool = false   // 👈 pass intent
	@FocusState private var isFocused: Bool

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			if showsLabel {
				Text(label)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}

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
			.task {
				if autoFocus {
					isFocused = true
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

struct CurrencyInput2: View {
	let label: String
	let placeholder: String
	let showsLabel: Bool
	@Binding var amount: String
	var autoFocus: Bool = false

	@FocusState private var isFocused: Bool

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			if showsLabel {
				Text(label)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}

			ZStack(alignment: .leading) {

				// Placeholder
				if amount.isEmpty {
					Text(placeholder)
						.font(.custom("OpenRunde-Bold", size: 36))
						.foregroundStyle(
							Color(red: 0.11, green: 0.18, blue: 0.23)
								.opacity(0.35)
						)
						.kerning(-0.32)
				}

				// DISPLAY TEXT (visual only)
				HStack(alignment: .firstTextBaseline, spacing: 0) {
					let parts = amount.split(separator: ".", omittingEmptySubsequences: false)

					Text(parts.first ?? "")
						.font(.custom("OpenRunde-Bold", size: 36))

					if parts.count > 1 {
						Text(".\(parts[1])")
							.font(.custom("OpenRunde-Bold", size: 24))
					}
				}
				.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
				.kerning(-0.8)
				.allowsHitTesting(false)              // ✅ critical
				.frame(minWidth: 0, alignment: .leading)

				// REAL INPUT (caret source)
				TextField("", text: $amount)
					.keyboardType(.decimalPad)
					.textFieldStyle(.plain)
					.font(.custom("OpenRunde-Bold", size: 36))
					.foregroundStyle(.clear)
					.accentColor(.blue)
					.focused($isFocused)
					.frame(minWidth: 0, alignment: .leading)
					.fixedSize(horizontal: true, vertical: false)
					.onChange(of: amount) { _, newValue in
						let formatted = formatAmount(newValue)
						if formatted != newValue {
							amount = formatted
						}
					}
			}
			.task {
				if autoFocus {
					isFocused = true
				}
			}
		}
	}

	// MARK: - Formatting (2 decimals max)
	// Industry standard formatter for currency
	private static let currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency // Handles commas, decimals, currency symbol placement
		formatter.currencyCode = "USD" // Or whatever currency you need
		formatter.maximumFractionDigits = 2
		formatter.minimumFractionDigits = 2 // Ensures $10 shows as $10.00
		return formatter
	}()


	private func formatAmount(_ value: String) -> String {
		let filtered = value.filter { "0123456789.".contains($0) }
		let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)

		if parts.count == 1 {
			return filtered
		}

		if parts.count >= 2 {
			return "\(parts[0]).\(parts[1].prefix(2))"
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
			HStack {

				CurrencyInput2(
					label: "will recieve",
					placeholder: "Amount",
					showsLabel: false,
					amount: $amountValue,
					autoFocus: true
				)
				CurrencyInput2(
					label: "will recieve",
					placeholder: "INR",
					showsLabel: false,
					amount: $amountValue
				)
			}

			Spacer()
		}
		.padding()
		.background(Color(.systemBackground))
	}
}
