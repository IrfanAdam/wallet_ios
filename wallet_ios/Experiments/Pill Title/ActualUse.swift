import SwiftUI

// MARK: --- Preview ---
struct SimpleFlowWrap_Preview: PreviewProvider {

	static var previewItems: [AnyView] {
		let sentence1 = "Jabari M. will send CFA 1500"
		let sentence2 = "for Groceries"
		let components1 = sentenceToAnyViewComponents(sentence1) {
			word in AnyView(Text(word))
		}
		let components2 = sentenceToAnyViewComponents(sentence2) {
			word in AnyView(Text(word))
		}
		return components1
		+ [AnyView(Pill(text: "Daylies"))]
		+ components2
		+ [AnyView(Pill(text: "Category"))]
		+ components2
		+ components2
	}

	static var previews: some View {
		SimpleFlowWrap(items: previewItems)
			.previewLayout(.sizeThatFits)
	}
}
