import SwiftUI
import UIKit

// MARK: - Single Tab Item View

struct LiquidGlassTabItem: View {
	let tab: LiquidGlassTab
	let isSelected: Bool
	
	var body: some View {
		VStack(spacing: 4) {
			Image(systemName: tab.icon)
				.font(.system(size: 22, weight: isSelected ? .semibold : .regular))
				.symbolVariant(isSelected ? .fill : .none)
				.foregroundStyle(isSelected ? .primary : .secondary)
				.scaleEffect(isSelected ? 1.1 : 1.0)
				.animation(.spring(response: 0.3, dampingFraction: 0.65), value: isSelected)
			
//			Text(tab.label)
//				.font(.system(size: 10, weight: isSelected ? .semibold : .medium))
//				.foregroundStyle(isSelected ? .primary : .secondary)
		}
		.frame(maxWidth: .infinity)
		// Disable hit testing so touches fall through to the UISegmentedControl
		.allowsHitTesting(false)
	}
}
