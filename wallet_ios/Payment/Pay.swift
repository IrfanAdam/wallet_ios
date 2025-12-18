import SwiftUI

struct InitiatePayment: View {
	var namespace: Namespace.ID
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss
	@State private var amountValue: String = ""
	@Environment(\.sheetControl) private var sheetControl


	@State private var integerPart: String = ""
	@State private var decimalPart: String = ""
	@FocusState private var focusInteger: Bool
	@FocusState private var focusDecimal: Bool


	var fullAmount: String {
		if decimalPart.isEmpty { integerPart }
		else { integerPart + "." + decimalPart }
	}



	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 4) {
				SimpleFlowWrap(
					items: paymentFlowItems
				)
				HStack(alignment: .top) {
					HStack {
						Text("CFA")
							.font(.custom("OpenRunde-Bold", size: 36))
							.foregroundStyle(Color(red: 0.4, green: 0.47, blue: 0.53))
							.kerning(-0.8)

						HStack(alignment: .firstTextBaseline, spacing: 0) {
							CurrencyInput(
								label: "Will recieve",
								placeholder: "00",
								showsLabel: false,
								amount: $amountValue,
								autoFocus: true
							)
							CurrencyInput(
								label: "Will recieve",
								placeholder: "00",
								showsLabel: false,
								amount: $amountValue,
								autoFocus: true
							)
						}
					}

					HStack {
						Button {

						} label: {
							Text("🇮🇳") // India flag
								.font(.title2)
							Text("INR")
						}
						.buttonStyle(.plain)
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.background(.thinMaterial)
						.clipped(antialiased: true)
						.clipShape(Capsule())
					}
				}.padding(.horizontal)

				Divider().padding(.horizontal)

				Spacer()
			}
			.navigationBarBackButtonHidden(true)
			.toolbar { toolbarContent }
		}
		.onAppear {
			sheetControl.setDetent(.medium)
		}
	}

	private var paymentFlowItems: [AnyView] {
		renderFlowItems([
			.text("Jabari M. LastName will recieve", tone: .primary),
//			.text("Jabari M. will recieve", tone: .primary),
//			.text("CFA 1500", tone: .primary),
//			.pill("Daylies"),
//			.text("for Groceries", tone: .secondary),
//			.pill("Category"),
//			.pill("Hahahah")
		])
	}


	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		// Remove default back Chevron
		ToolbarItem(placement: .topBarLeading) {
			ZStack() {
				HStack(spacing: overlapSpacing) {
					CutoutAvatarView()
					CutoutAvatarView()
					StrokedIconView()
				}
				.overlay(
					Capsule()
						.stroke(Color.white, lineWidth: 2)
				)
				.compositingGroup()
			}.onTapGesture {
				dismiss()
			}
			.background(.ultraThinMaterial)
			.clipShape(Capsule())
		}

		ToolbarSpacer(.flexible)

		ToolbarItem(placement: .destructiveAction) {
			Button("Close", systemImage: "xmark") {
				sheetControl.dismiss()
			}
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
	}
}
