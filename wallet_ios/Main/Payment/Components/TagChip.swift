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

