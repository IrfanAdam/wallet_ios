import SwiftUI

struct InitiatePayment: View {
	var namespace: Namespace.ID
	@State private var selectedTab: Int = 0
	@Environment(\.dismiss) private var dismiss
	@State private var amountValue: String = ""
	@Environment(\.sheetControl) private var sheetControl

	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				SimpleFlowWrap(
					items: FlowSentenceRenderer.makeItems(
						primary: "Jabari M. will send CFA 1500",
						secondary: "for Groceries"
					)
				).padding(.horizontal)
				CurrencyInput(placeholder: "Enter amount", amount: $amountValue).padding(.horizontal)
			}
			.onAppear {
				sheetControl.setDetent(.medium)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
			).navigationBarBackButtonHidden(true)
			.toolbar { toolbarContent }
		}
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

struct FlowSentenceRenderer {
	
	static func makeItems(
		primary: String,
		secondary: String
	) -> [AnyView] {
		
		let primaryWords = sentenceToAnyViewComponents(primary) { word in
			AnyView(
				Text(word)
					.font(.custom("OpenRunde-Bold", size: 36))
					.kerning(-0.2)
					.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
			)
		}
		
		let secondaryWords = sentenceToAnyViewComponents(secondary) { word in
			AnyView(
				Text(word)
					.font(.custom("OpenRunde-Bold", size: 36))
					.kerning(-0.2)
					.foregroundStyle(Color(red: 0.4, green: 0.47, blue: 0.53))
			)
		}
		
		return primaryWords
		+ [AnyView(Pill(text: "Daylies"))]
		+ secondaryWords
		+ [AnyView(Pill(text: "Category"))]
		+ secondaryWords
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
