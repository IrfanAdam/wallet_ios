import SwiftUI

func renderFlowItems(_ items: [FlowItem]) -> [AnyView] {
	items.flatMap { item in
		switch item {

		case let .text(sentence, tone):
			sentence
				.split(separator: " ")
				.map { word in
					AnyView(
						Text(word)
							.font(.custom("OpenRunde-Bold", size: 36))
							.kerning(-0.2)
							.foregroundStyle(tone.color)
					)
				}

		case let .pill(text):
			[
				AnyView(
					Pill(text: text)
				)
			]
		}
	}
}


// MARK: - Sentence → AnyView Components
func sentenceToAnyViewComponents(
	_ sentence: String,
	transform: (String) -> AnyView
) -> [AnyView] {
	sentence.split(separator: " ").map {
		transform(String($0))
	}
}

