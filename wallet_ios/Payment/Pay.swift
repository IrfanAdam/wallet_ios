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
	
	// MARK: - Animation Configurations
	// Ultra-fast for authentication transition
	private let instantSpring = Animation.spring(response: 0.2, dampingFraction: 0.95, blendDuration: 0)
	
	// Snappy spring for quick interactions
	private let snappySpring = Animation.spring(response: 0.25, dampingFraction: 0.92, blendDuration: 0)
	
	// Smooth spring for dismissals
	private let smoothSpring = Animation.spring(response: 0.3, dampingFraction: 0.88, blendDuration: 0)
	
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
				}
				.padding(.horizontal)
				
				Divider()
					.padding(.horizontal)
					.padding(.vertical, 0)
				
				Spacer()
				
				bottomActionArea
					.padding(isAuthenticating ? [] : .horizontal)
					.padding(isAuthenticating ? [] : .vertical)
					.animation(instantSpring, value: isAuthenticating)
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
			}
			.onTapGesture {
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
					withAnimation(smoothSpring) {
						isAuthenticating = false
					}
				}
			)
			.transition(.move(edge: .bottom).combined(with: .opacity))
		} else {
			PaymentCTAView(
				hasContinued: hasContinued,
				isAuthenticating: isAuthenticating,
				namespace: namespace,
				onContinue: {
					withAnimation(snappySpring) {
						hasContinued = true
					}
				},
				onPayNow: {
					withAnimation(instantSpring) {
						isAuthenticating = true
					}
				},
				onPayLater: {
					// pay later logic
				}
			)
			.transition(.move(edge: .bottom).combined(with: .opacity))
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
