import SwiftUI

struct TagChip: View {
	let title: String
	let isSelected: Bool
	let onTap: () -> Void
	
	var body: some View {
		Button(action: onTap) {
			Text(title)
				.font(.subheadline.weight(.medium))
				.foregroundStyle(.primary)
				.padding(.horizontal, 14)
				.padding(.vertical, 8)
				.background(
					Capsule()
						.fill(isSelected ? Color.primary.opacity(0.1) : Color.clear)
				)
				.overlay(
					Capsule()
						.stroke(
							isSelected ? Color.primary : Color.secondary.opacity(0.4),
							lineWidth: 1
						)
				)
		}
		.buttonStyle(.plain)
	}
}


// MARK: --- Example Pill ---
struct Pill: View {
	let text: String


	var body: some View {
		Text(text)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(Capsule().stroke(Color.gray, lineWidth: 1))
	}
}
