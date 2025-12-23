import SwiftUI

struct CurrencyTwoFieldDemo: View {

	@State private var integerPart: String = "123456"
	@State private var fractionPart: String = "45"
	@State private var showFraction: Bool = false

	@Environment(\.locale) private var locale

	enum Field {
		case integer
		case fraction
	}

	@FocusState private var focus: Field?

	var currencyCode: String = Locale.current.currency?.identifier ?? "USD"

	private var formatter: NumberFormatter {
		let f = NumberFormatter()
		f.numberStyle = .currency
		f.currencyCode = currencyCode
		f.minimumFractionDigits = 2
		f.maximumFractionDigits = 2
		return f
	}

	private let integerFormatter = CurrencyFormatter.makeGroupedCurrencyFormatter()

	private var formattedInteger: String {
		CurrencyFormatter.formatLive(input: integerPart, formatter: integerFormatter)
	}

	private var fractionDigits: Int {
		formatter.maximumFractionDigits
	}

	private var isEditingFraction: Bool {
		focus == .fraction || !fractionPart.isEmpty
	}

	private func initializeValues() {
		integerPart = CurrencyFormatter.formatLive(
			input: integerPart,
			formatter: integerFormatter
		)
		showFraction = !fractionPart.isEmpty
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 24) {

			HStack(alignment: .firstTextBaseline, spacing: 0) {

				// MARK: - Integer Field
				TextField("", text: $integerPart)
					.keyboardType(.decimalPad)
					.focused($focus, equals: .integer)
					.fixedSize(horizontal: true, vertical: false)
					.onChange(of: integerPart) { oldValue, newValue in

						// ----------------------------------------------------
						// 1️⃣ Handle decimal entry (including repeated taps)

						if newValue.contains(".") {

							// Always reset fraction when decimal is tapped
							let parts = newValue.split(
								separator: ".",
								omittingEmptySubsequences: false
							)

							let intPart = String(parts.first ?? "")
								.filter(\.isNumber)

							integerPart = intPart.isEmpty ? "0" : intPart
							fractionPart = ""
							showFraction = true
							focus = .fraction
							return
						}

						// ----------------------------------------------------
						// 2️⃣ Normal integer typing
						// ----------------------------------------------------
						let digitsOnly = newValue.filter(\.isNumber)
						let cleaned = digitsOnly.drop(while: { $0 == "0" })

						integerPart = cleaned.isEmpty ? "0" : String(cleaned)

						integerPart = CurrencyFormatter.formatLive(
							input: integerPart,
							formatter: integerFormatter
						)
					}
					.font(.custom("OpenRunde-Bold", size: 36))
					.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
					.kerning(-0.8)

				// MARK: - Decimal Dot
				if showFraction && fractionDigits > 0 && isEditingFraction {
					Text(".")
						.font(.system(size: 36, weight: .bold))
				}

				// MARK: - Fraction Field
				if showFraction && fractionDigits > 0 {
					TextField("00", text: $fractionPart)
						.keyboardType(.decimalPad)
						.focused($focus, equals: .fraction)
						.fixedSize(horizontal: true, vertical: false)
						.onChange(of: fractionPart) { _, newValue in
							let digitsOnly = newValue.filter(\.isNumber)
							fractionPart = String(digitsOnly.prefix(fractionDigits))

							showFraction = !fractionPart.isEmpty

							if fractionPart.isEmpty {
								focus = .integer
							}
						}
						.font(.custom("OpenRunde-Bold", size: 24))
						.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
						.kerning(-0.8)
				}
			}
		}
		.padding(0)
		.onAppear {
			focus = .integer
			initializeValues()
		}
	}
}

// MARK: - Preview
#Preview {
	CurrencyTwoFieldDemo()
}
