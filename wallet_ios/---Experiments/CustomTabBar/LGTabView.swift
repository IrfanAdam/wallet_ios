import SwiftUI
import UIKit


// MARK: - Full Tab View Container (convenience wrapper)

public struct LiquidGlassTabView<Content: View>: View {
	@ViewBuilder let content: (Int) -> Content
	@State private var activeTab: CustomTab = .home

	public var body: some View {
		ZStack(alignment: .bottom) {
			// Page content
			content(activeTab.index)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.ignoresSafeArea()
			
			GlassEffectContainer {
				
				HStack(spacing: 12) {
					GeometryReader {
						GlassSegmentedControl(size: $0.size, activeTab: $activeTab) { tab in
							VStack(spacing: 4) {
								Image(systemName: tab == activeTab ? "\(tab.symbol).fill" : tab.symbol)
									.font(.system(size: 24, weight: .semibold))
							}
						}
					}
					.glassEffect(.clear.interactive(true).tint(Color.white.opacity(0.48)), in: .capsule)


					Button(action: {
						print("Button tapped")
					}) {
						Image(systemName: "magnifyingglass")
							.font(.system(size: 22, weight: .semibold))
							.foregroundStyle(Color.white.opacity(0.8))
							.frame(width: 44, height: 44)
					}
					.padding(8)
					.buttonStyle(.plain)
					.glassEffect(.clear.interactive(true).tint(Color.blue.opacity(0.9)), in: .capsule)

				}
				.padding(.horizontal, 16)
				.frame(height: 56)
				.frame(maxWidth: .infinity)
			}
			.shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
		}
	}
}

