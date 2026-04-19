import SwiftUI
import UIKit

// MARK: - Preview / Demo

#Preview {
	DemoView()
}

struct DemoView: View {
	@State private var selectedTab = 0
	
	let tabs = [
		LiquidGlassTab(icon: "house",        label: "Home",    tag: 0),
		LiquidGlassTab(icon: "magnifyingglass", label: "Search", tag: 1),
		LiquidGlassTab(icon: "bell",          label: "Alerts",  tag: 2),
		LiquidGlassTab(icon: "person",        label: "Profile", tag: 3),
	]
	
	// Demo gradient backgrounds per tab
	let gradients: [AnyGradient] = [
		Color.blue.gradient,
		Color.purple.gradient,
		Color.orange.gradient,
		Color.green.gradient,
	]
	
	var body: some View {
		LiquidGlassTabView(tabs: tabs, selectedIndex: $selectedTab) { index in
			ZStack {
				Rectangle()
					.fill(gradients[index])
					.ignoresSafeArea()
				
				VStack(spacing: 12) {
					
					ScrollView {
						Image(systemName: tabs[index].icon)
							.font(.system(size: 60, weight: .thin))
							.foregroundStyle(.white)
							.padding(.top, 120)
						Text(tabs[index].label)
							.font(.largeTitle.bold())
							.foregroundStyle(.white)
						
						VStack(alignment: .leading, spacing: 16) {
							ForEach(0..<20) { _ in
								Text("""
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
						Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
						Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
						""")
							}
						}
						.font(.body)
						.foregroundStyle(.white.opacity(0.9))
						.padding()
					}
				}
			}
		}
	}
}
