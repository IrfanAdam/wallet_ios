import SwiftUI

// MARK: --- Preview ---
struct SimpleFlowWrap_Preview: PreviewProvider {
	static var previewItems: [AnyView] {
		let phrase1 = "Jabari M. will send CFA 1500"
		let phrase2 = "for Groceries"
		let components1 = sentenceToAnyViewComponents(phrase1) {
			word in AnyView(
				Text(word)
					.font(.custom("OpenRunde-Bold", size: 36))
					.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.23))
					.kerning(-0.2)
			)
		}
		let dimText = sentenceToAnyViewComponents(phrase2) {
			word in AnyView(
				Text(word)
					.font(.custom("OpenRunde-Bold", size: 36))
					.kerning(-0.2)
					.foregroundStyle(Color(red: 0.4, green: 0.47, blue: 0.53))
			)
		}
		return components1
		+ [AnyView(Pill(text: "Daylies"))]
		+ dimText
		+ [AnyView(Pill(text: "Category"))]
		+ dimText
		+ dimText
	}

	static var previews: some View {
		SimpleFlowWrap(items: previewItems)
			.previewLayout(.sizeThatFits)
	}
}
