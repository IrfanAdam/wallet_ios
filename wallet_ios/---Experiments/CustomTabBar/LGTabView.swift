import SwiftUI
import UIKit

// MARK: - Tab Item Model

public struct LiquidGlassTab {
	public let icon: String          // SF Symbol name
	public let label: String
	public let tag: Int
	
	public init(icon: String, label: String, tag: Int) {
		self.icon = icon
		self.label = label
		self.tag = tag
	}
}

// MARK: - Full Tab View Container (convenience wrapper)

public struct LiquidGlassTabView<Content: View>: View {
	let tabs: [LiquidGlassTab]
	@Binding var selectedIndex: Int
	@ViewBuilder let content: (Int) -> Content
	
	public init(
		tabs: [LiquidGlassTab],
		selectedIndex: Binding<Int>,
		@ViewBuilder content: @escaping (Int) -> Content
	) {
		self.tabs = tabs
		self._selectedIndex = selectedIndex
		self.content = content
	}
	
	public var body: some View {
		ZStack(alignment: .bottom) {
			// Page content
			content(selectedIndex)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()
			
			GlassEffectContainer {
				
				HStack(spacing: 12) {
					
					// Floating glass tab bar
					LiquidGlassTabBar(tabs: tabs, selectedIndex: $selectedIndex)
						.glassEffect(.clear.interactive().tint(Color.white.opacity(0.2)), in: .capsule)
					
					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "magnifyingglass")
							.font(.system(size: 22, weight: .semibold))
							.foregroundStyle(Color.white.opacity(0.8))
							.frame(width: 56, height: 56)
					}
					.buttonStyle(.glass(.clear.interactive().tint(Color.blue)))
					.padding(0)
				}
				.padding(.horizontal, 16)
			}
		}
	}
}

