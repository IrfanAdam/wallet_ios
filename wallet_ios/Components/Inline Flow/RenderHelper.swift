import SwiftUI

struct FlowRenderer: View {
	let items: [FlowItemNew]

	var body: some View {
		FlowLayout {
			ForEach(items, id: \.self) { item in
				switch item {
					case let .text(sentence, tone):
						ForEach(sentence.split(separator: " "), id: \.self) { word in
							FlowWord(
								text: String(word),
								tone: tone
							) {
								print("Tapped word:", word)
							}
						}

					case let .pill(text): Pill(text: text).padding(.horizontal, 4)
				}
			}
		}
	}
}

struct FlowWord: View {
	let text: String
	let tone: Tone
	let onTap: () -> Void

	var body: some View {
		Text(text)
			.font(.custom("OpenRunde-Bold", size: 36))
			.kerning(-0.2)
			.foregroundStyle(tone.color)
			.contentShape(Rectangle()) // important
			.onTapGesture {
				onTap()
			}
	}
}
