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
	let cardHeight: CGFloat
	let swapPosition: Int
	let swapCount: Int
	let borderOpacity: Double
	let onSwap: (WalletSwapDirection) -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
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
				
				VStack {
						if isTopCard {
							WalletCardSwapPill(
								position: swapPosition,
								count: swapCount,
								onSwap: onSwap
							)
							.padding(0)
						}
				}
				.padding(0)
			}
			
			Spacer()
			
			HStack(spacing: 8) {
				HStack(spacing: -8) {
					avatar("D")
					avatar("K")
				}
				.padding(.leading, 3)
				
				Image(systemName: "arrow.up.right")
					.font(.system(size: 14, weight: .bold))
					.foregroundStyle(.white.opacity(0.78))
			}
			.frame(height: 28)
			.padding(.horizontal, 8)
			.background(Color.white.opacity(0.13))
			.clipShape(Capsule())
			.overlay(Capsule().stroke(Color.white.opacity(0.25)))
		}
		.padding(16)
		.frame(maxWidth: .infinity)
		.frame(height: cardHeight, alignment: .bottom)
		.background(Color(red: 0.02, green: 0.29, blue: 0.62))
		.clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
		.overlay(
			RoundedRectangle(cornerRadius: 36, style: .continuous)
				.stroke(Color.white.opacity(borderOpacity), lineWidth: 2)
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

enum WalletSwapDirection {
	case previous
	case next
}

enum WalletShufflePhase: Equatable {
	case idle
	case departing(WalletSwapDirection)
	case arriving(WalletSwapDirection)
}

private struct WalletCardSwapPill: View {
	let position: Int
	let count: Int
	let onSwap: (WalletSwapDirection) -> Void
	
	var body: some View {
		VStack(spacing: 4) {
			Image(systemName: "chevron.up")
				.font(.system(size: 15, weight: .bold))
			Text("\(position)/\(count)")
				.font(.system(size: 16, weight: .bold))
			Image(systemName: "chevron.down")
				.font(.system(size: 15, weight: .bold))
		}
		.foregroundStyle(.white.opacity(0.78))
		.background(Color.white.opacity(0.12))
		.clipShape(Capsule())
		.overlay(Capsule().stroke(Color.white.opacity(0.18)))
		.contentShape(Capsule())
		.highPriorityGesture(
			DragGesture(minimumDistance: 8)
				.onEnded { value in
					guard abs(value.translation.height) > 18 else { return }
					onSwap(value.translation.height < 0 ? .previous : .next)
				}
		)
	}
}
