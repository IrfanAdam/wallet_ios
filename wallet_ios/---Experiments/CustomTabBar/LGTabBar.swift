import SwiftUI
import UIKit

// MARK: - The Main Liquid Glass Tab Bar

public struct LiquidGlassTabBar: View {
	let tabs: [LiquidGlassTab]
	@Binding var selectedIndex: Int
	
	public init(tabs: [LiquidGlassTab], selectedIndex: Binding<Int>) {
		self.tabs = tabs
		self._selectedIndex = selectedIndex
	}
	
	public var body: some View {
		ZStack {
			// Layer 1: The invisible UISegmentedControl that provides the glass bubble
			GlassSegmentedControl(count: tabs.count, selectedIndex: $selectedIndex)
			
			// Layer 2: Our fully custom tab item views on top
			HStack(spacing: 0) {
				ForEach(tabs, id: \.tag) { tab in
					LiquidGlassTabItem(
						tab: tab,
						isSelected: selectedIndex == tab.tag
					)
				}
			}
			.allowsHitTesting(false) // Touches pass through to UISegmentedControl below
			.padding(.vertical, 12)
		}
	}
}
