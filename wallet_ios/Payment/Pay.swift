import SwiftUI

struct InitiatePayment: View {
	var namespace: Namespace.ID
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss
	@State private var amountValue: String = ""
	@Environment(\.sheetControl) private var sheetControl
	@State private var hasContinued: Bool = false
	@State private var isAuthenticating: Bool = false


	@State private var integerPart: String = ""
	@State private var decimalPart: String = ""
	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool
	@State private var selectedCurrency = "INR"


	private func flag(for currency: String) -> String {
		switch currency {
		case "INR": return "🇮🇳"
		case "USD": return "🇺🇸"
		case "EUR": return "🇪🇺"
		default: return "🏳️"
		}
	}


	var fullAmount: String {
		if decimalPart.isEmpty { integerPart }
		else { integerPart + "." + decimalPart }
	}


	@ViewBuilder
	private func currencyButton(_ code: String, _ name: String) -> some View {
		Button {
			selectedCurrency = code
		} label: {
			HStack {
				Text("\(code) – \(name)")
				Spacer()

				if selectedCurrency == code {
					Image(systemName: "checkmark")
				}
			}
		}
	}



	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 12) {
				SimpleFlowWrap(
					items: paymentFlowItems
				)
				
				HStack(alignment: .bottom) {
					HStack {
						//						Text("CFA")
						//							.font(.custom("OpenRunde-Bold", size: 36))
						//							.foregroundStyle(Color(red: 0.4, green: 0.47, blue: 0.53))
						//							.kerning(-0.8)
						
						HStack(alignment: .firstTextBaseline, spacing: 0) {
							CurrencyTwoFieldDemo()
						}
					}
					
					Spacer()
					
					Menu {
						currencyButton("INR", "Indian Rupee")
						currencyButton("USD", "US Dollar")
						currencyButton("EUR", "Euro")
					} label: {
						HStack(spacing: 4) {
							Text(flag(for: selectedCurrency))
								.font(.title2)
							
							Text(selectedCurrency)
								.font(.body.weight(.medium))
							
						}
						.buttonStyle(.plain)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(.thinMaterial)
						.clipped(antialiased: true)
						.clipShape(Capsule())
					}
				}.padding(.horizontal)
				
				Divider().padding(.horizontal).padding(.vertical, 0)
				
				Spacer()
				
				bottomActionArea
					.padding(isAuthenticating ? [] : .horizontal)
					.padding(isAuthenticating ? [] : .vertical)
					.animation(.spring(response: 0.45, dampingFraction: 0.85),
										 value: isAuthenticating)
				
			}
			.background(Color.clear)
			.navigationBarBackButtonHidden(true)
			.toolbar { toolbarContent }
			.ignoresSafeArea(.container, edges: isAuthenticating ? .bottom : [])
			.ignoresSafeArea(isAuthenticating ? .keyboard : [], edges: isAuthenticating ? .bottom : [])
		}
		.onAppear {
			sheetControl.setDetent(.medium)
		}
		.ignoresSafeArea(edges: isAuthenticating ? .bottom : [])
	}

	private var paymentFlowItems: [AnyView] {
		renderFlowItems([
			.text("Jabari M. Last Name", tone: .primary),
//			.text("Jabari M. will recieve", tone: .primary),
//			.text("CFA 1500", tone: .primary),
//			.pill("Daylies"),
//			.text("for Groceries", tone: .secondary),
//			.pill("Category"),
//			.pill("Hahahah")
		])
	}

	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card"))),
	]


	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			HStack(spacing: 0) {
				AvatarStack(
					avatars: avatars,
					avatarSize: 32,
					strokeWidth: 2.25,
					showBackground: true
				)
			}
			.scaledToFill()
			.clipShape(Capsule())
			.background {
				Capsule().fill(Color.blue)
			}.onTapGesture {
				dismiss()
			}
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") {
				sheetControl.dismiss()
			}
		}
	}
	
	@ViewBuilder
	private var bottomActionArea: some View {
		if isAuthenticating {
			PaymentAuthView(
				amount: "\(selectedCurrency) \(fullAmount)",
				namespace: namespace,
				onDismiss: {
					withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
						isAuthenticating = false   // <-- reset to initial state
					}
				}
			)
			.transition(.opacity)
		} else {
			PaymentCTAView(
				hasContinued: hasContinued,
				isAuthenticating: isAuthenticating,
				namespace: namespace,
				onContinue: {
					withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
						hasContinued = true
					}
				},
				onPayNow: {
					withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
						isAuthenticating = true
					}
				},
				onPayLater: {
					// pay later logic
				}
			)
		}
	}

	struct ProfileImage: View {
		let imageName: String
		let size: CGFloat = 36

		var body: some View {
			Image(imageName)           
				.resizable()
				.scaledToFill()
				.frame(width: size, height: size)
				.clipShape(Circle())
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
