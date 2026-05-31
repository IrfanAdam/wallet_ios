import SwiftUI

struct Wallet: Identifiable {
	let id = UUID()
	let currency: String
	let amount: String
	let flag: String
}


struct WalletCardView: View {
	let wallet: Wallet
	let isTopCard: Bool
	let progress: CGFloat
	let overCollapseProgress: CGFloat
	let cardHeight: CGFloat
	let borderOpacity: Double
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(alignment: .top) {
				HStack(alignment: .firstTextBaseline, spacing: 3) {
						Text(wallet.amount)
						Text(wallet.currency)
							.foregroundStyle(.white.opacity(0.68))
				}
				.font(.system(size: 24, weight: .bold))
				.foregroundStyle(Color.white)
				
				Spacer()
				
				Text(wallet.flag)
					.font(.system(size: 24))
					.frame(width: 32, height: 32)
					.background(Color.white.opacity(0.14))
					.clipShape(Circle())
			}

			HStack {
				HStack(spacing: 4) {
					HStack(spacing: -8) {
						avatar("D")
						avatar("K")
					}

					Image(systemName: "arrow.up.right")
						.font(.system(size: 14, weight: .bold))
						.foregroundStyle(.white.opacity(0.78))
						.padding(.horizontal, 2)
				}
				.padding(4)
				.background(Color.white.opacity(0.13))
				.clipShape(Capsule())
				.overlay(Capsule().stroke(Color.white.opacity(0.25)))
			}

			if isTopCard {
				if progress > 0.5 { Spacer() }
				HStack(spacing: 8) {
					GlassOptionButton(systemName: "checkmark.seal") {
						// TODO: seal action
					}
					GlassOptionButton(systemName: "lock") {
						// TODO: lock action
					}
					GlassOptionButton(systemName: "calendar.badge.checkmark") {
						// TODO: calendar action
					}
					GlassOptionButton(systemName: "bell") {
						// TODO: bell action
					}
					GlassOptionButton(systemName: "gearshape") {
						// TODO: settings action
					}
				}
				.padding(.vertical, progress < 0.5 ? 8 : 0)
				.opacity(1 - overCollapseProgress)
				.scaleEffect(1 - 0.15 * overCollapseProgress)
				if progress < 0.5 { Spacer() }
			}

		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.frame(height: cardHeight, alignment: .top)
		.background(Color(red: 0.02, green: 0.29, blue: 0.62))
		.clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
		.overlay(
			RoundedRectangle(cornerRadius: 36, style: .continuous)
				.stroke(Color(red: 0.97, green: 0.95, blue: 0.92), lineWidth: 2)
		)
	}
	
	private func avatar(_ letter: String) -> some View {
		Text(letter)
			.font(.system(size: 10, weight: .bold))
			.foregroundStyle(.white)
			.frame(width: 20, height: 20)
			.background(Color(red: 0.72, green: 0.48, blue: 0.30))
			.clipShape(Circle())
			.overlay(Circle().stroke(.white, lineWidth: 1))
	}
}
