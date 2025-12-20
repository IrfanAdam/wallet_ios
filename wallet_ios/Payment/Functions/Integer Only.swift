import SwiftUI

// MARK: - Reusable NumberFormatter Helper
struct CurrencyFormatter {
	static func makeGroupedCurrencyFormatter(
		currencyCode: String = "INR",
		locale: Locale = Locale(identifier: "en_IN"),
		maximumFractionDigits: Int = 0,
		minimumFractionDigits: Int = 0
	) -> NumberFormatter {
		let f = NumberFormatter()
		f.numberStyle = .currency
		f.currencyCode = currencyCode
		f.locale = locale
		f.maximumFractionDigits = maximumFractionDigits
		f.minimumFractionDigits = minimumFractionDigits
		f.usesGroupingSeparator = true
		return f
	}

	static func formatLive(input: String, formatter: NumberFormatter) -> String {
		let digits = input.filter { $0.isNumber }

		guard !digits.isEmpty else { return "" }

		let number = Double(digits) ?? 0
		return formatter.string(from: NSNumber(value: number)) ?? input
	}
}

// MARK: - Realtime integer input demo using reusable helpers
struct RealtimeIntegerDemo: View {
	@State private var amountText: String = ""

	private let formatter = CurrencyFormatter.makeGroupedCurrencyFormatter()

	var body: some View {
		TextField("Amount", text: $amountText)
			.keyboardType(.numberPad)
			.font(.system(size: 28, weight: .semibold))
			.onChange(of: amountText) { _, newValue in
				amountText = CurrencyFormatter.formatLive(input: newValue, formatter: formatter)
			}
			.padding(12)
	}
}

// MARK: - Preview
#Preview {
	RealtimeIntegerDemo()
}
