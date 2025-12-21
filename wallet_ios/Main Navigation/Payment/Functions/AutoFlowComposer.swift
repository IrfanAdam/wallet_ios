import SwiftUI

enum FlowTone {
	case primary
	case secondary

	var color: Color {
		switch self {
		case .primary:
			return Color(red: 0.11, green: 0.18, blue: 0.23)
		case .secondary:
			return Color(red: 0.4, green: 0.47, blue: 0.53)
		}
	}
}

enum FlowItem {
	case text(String, tone: FlowTone)
	case pill(String)
}


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
