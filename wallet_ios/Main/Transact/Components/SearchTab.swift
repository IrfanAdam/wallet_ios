import SwiftUI

struct SearchTab: View {
	let title: String
	let icon: String
	let index: Int
	@Binding var selectedTab: Int
	
	var isSelected: Bool {
		selectedTab == index
	}
	
	var body: some View {
		Button {
			selectedTab = index
		} label: {
			HStack(spacing: 6) {
				Image(systemName: icon)
				if isSelected {
					Text(title)
						.transition(.opacity.combined(with: .move(edge: .trailing)))
				}
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(isSelected ? Color.blue : Color.white.opacity(0.5))
			)
			.background(.thinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 14))
			.foregroundStyle(isSelected ? .white : .primary)
			.animation(.easeInOut(duration: 0.2), value: isSelected)
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	PreviewWrapper()
}

private struct PreviewWrapper: View {
	@State private var selectedTab = 0
	
	var body: some View {
		HStack(spacing: 12) {
			SearchTab(
				title: "Search",
				icon: "magnifyingglass",
				index: 0,
				selectedTab: $selectedTab
			)
			
			SearchTab(
				title: "Filters",
				icon: "slider.horizontal.3",
				index: 1,
				selectedTab: $selectedTab
			)
		}
		.padding()
	}
}
