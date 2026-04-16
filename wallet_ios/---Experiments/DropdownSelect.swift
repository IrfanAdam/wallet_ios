import SwiftUI

struct TitleDropdownView: View {
	@State private var selected = "Upcoming"

	let options = ["Upcoming", "Past", "All"]

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			Text("Selected: \(selected)")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.blue)

				.toolbar {
					TitleToolbar(
						selected: selected,
						options: options,
						onDismiss: { dismiss() },
						onSelect: { option in
							withAnimation(.smooth(duration: 0.1)) {
								selected = option
							}
						}
					)
				}
		}
	}
}

struct TitleToolbar: ToolbarContent {
	let selected: String
	let options: [String]

	let onDismiss: () -> Void
	let onSelect: (String) -> Void

	var body: some ToolbarContent {
		ToolbarItem(placement: .topBarLeading) {
			leading
		}
		.sharedBackgroundVisibility(.hidden)

		ToolbarItem(placement: .topBarTrailing) {
			Button(action: onDismiss) {
				Image(systemName: "xmark")
			}
		}
	}

	@ViewBuilder
	private var leading: some View {
		switch selected {
		case "Upcoming":
			menuTitle("Upcoming")
		case "Past":
			menuTitle("Past")
		default:
			menuTitle("All")
		}
	}

	private func menuTitle(_ text: String) -> some View {
		Menu {
			ForEach(options, id: \.self) { option in
				Button {
					onSelect(option)
				} label: {
					Label(
						option,
						systemImage: option == selected ? "checkmark" : ""
					)
				}
			}
		} label: {
			HStack(spacing: 4) {
				Text(text)
					.font(.title)
					.fontWeight(.bold)

				Image(systemName: "chevron.down")
					.fontWeight(.bold)
			}
		}
	}
}

#Preview {
	TitleDropdownView()
}
