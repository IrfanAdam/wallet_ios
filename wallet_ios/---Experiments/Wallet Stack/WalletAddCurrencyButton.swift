import SwiftUI

struct WalletAddCurrencyButton: View {
	var body: some View {
		HStack(spacing: 8) {
			Text("Add Currency")
				.font(.system(size: 14, weight: .bold))
			Image(systemName: "plus")
				.font(.system(size: 19, weight: .semibold))
		}
		.padding(.horizontal, 10)
		.frame(height: 32)
		.background(.white.opacity(0.9))
		.clipShape(Capsule())
		.overlay(Capsule().stroke(Color.black.opacity(0.06)))
	}
}
