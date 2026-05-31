import SwiftUI

struct WalletContentPanel: View {
	let progress: CGFloat
	let panelData: WalletPanelData
	let isLoading: Bool
	
	var body: some View {
		VStack(spacing: 0) {
			Capsule()
				.fill(Color.black.opacity(0.12))
				.frame(width: 62, height: 4)
				.padding(.top, 4)
				.opacity(progress > 0.15 ? 1 : 0)

			primaryActions.padding(.top, 8)

				
			statusChips
				.padding(.top, 16)
				.walletLoading(isLoading)
			
			recents
				.padding(.top, 18)
				.walletLoading(isLoading)
		}
		.frame(maxWidth: .infinity)
		.background(
			UnevenRoundedRectangle(topLeadingRadius: 42, topTrailingRadius: 42)
				.fill(.white)
				.shadow(color: .black.opacity(0.08), radius: 18, y: -6)
		)
	}
	
	private var primaryActions: some View {
		HStack(spacing: 8) {
			WalletActionButton(systemName: "plus")
			WalletActionButton(systemName: "arrow.up")
			WalletActionButton(systemName: "shuffle")
			WalletActionButton(systemName: "building.columns")
			WalletActionButton(systemName: "square.grid.3x3")
		}
		.padding(.horizontal, 16)
	}
	
	private var statusChips: some View {
		HStack(spacing: 8) {
			WalletStatusChip(icon: "gift", text: "\(panelData.rewardsCount)", tint: .green)
			WalletStatusChip(icon: "hourglass", text: "\(panelData.pendingCount) Pending", tint: .orange)
			WalletStatusChip(icon: "clock.badge", text: "\(panelData.upcomingCount) Upcoming", tint: .blue)
			Spacer(minLength: 0)
		}
		.padding(.horizontal, 16)
	}
	
	private var recents: some View {
		VStack(spacing: 0) {
			ForEach(Array(panelData.transactions.enumerated()), id: \.element.id) { index, transaction in
				WalletTransactionCard(
					title: transaction.title,
					subtitle: transaction.subtitle,
					date: transaction.date,
					amount: transaction.amount,
					icon: transaction.icon,
					avatar: transaction.avatar
				)
				
				if index < panelData.transactions.count - 1 {
					Divider().padding(.leading, 16)
				}
			}
			
			HStack(spacing: 8) {
				Text("see all transactions")
					.font(.system(size: 14, weight: .bold))
				Image(systemName: "arrow.right")
			}
			.foregroundStyle(.blue)
			.padding(.top, 26)
			.padding(.bottom, 240)
		}
		.padding(.horizontal, 8)
	}
}

private struct WalletLoadingModifier: ViewModifier {
	let isLoading: Bool
	@State private var isAnimating = false
	
	func body(content: Content) -> some View {
		content
			.redacted(reason: isLoading ? .placeholder : [])
			.overlay {
				if isLoading {
					GeometryReader { proxy in
						LinearGradient(
							colors: [
								.white.opacity(0),
								.white.opacity(0.55),
								.white.opacity(0)
							],
							startPoint: .leading,
							endPoint: .trailing
						)
						.frame(width: proxy.size.width * 0.55)
						.offset(x: isAnimating ? proxy.size.width * 1.15 : -proxy.size.width * 0.65)
					}
					.mask(content.redacted(reason: .placeholder))
					.allowsHitTesting(false)
				}
			}
			.onAppear {
				withAnimation(.linear(duration: 1.05).repeatForever(autoreverses: false)) {
					isAnimating = true
				}
			}
			.animation(.easeInOut(duration: 0.16), value: isLoading)
	}
}

private extension View {
	func walletLoading(_ isLoading: Bool) -> some View {
		modifier(WalletLoadingModifier(isLoading: isLoading))
	}
}



private struct WalletOptionButton: View {
    let label: String
    let systemName: String
    
    var body: some View {
        Button {} label: {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(label == "settings" ? Color(red: 0.18, green: 0.25, blue: 0.30) : .blue)
                .frame(width: 44, height: 44)
                .background(Color(red: 0.98, green: 0.97, blue: 0.95))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black.opacity(0.06)))
        }
        .accessibilityLabel(label)
    }
}

private struct WalletActionButton: View {
	let systemName: String
	
	var body: some View {
		Button {} label: {
			Image(systemName: systemName)
				.font(.system(size: 24, weight: .medium))
				.foregroundStyle(Color(red: 0.14, green: 0.20, blue: 0.24))
				.frame(maxWidth: .infinity)
				.frame(height: 64)
				.background(.white)
				.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
				.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.08)))
		}
	}
}

private struct WalletStatusChip: View {
	let icon: String
	let text: String
	let tint: Color
	
	var body: some View {
		HStack(spacing: 7) {
			Image(systemName: icon)
				.font(.system(size: 18, weight: .semibold))
			Text(text)
				.font(.system(size: 14, weight: .bold))
		}
		.foregroundStyle(tint)
		.padding(.horizontal, 10)
		.frame(height: 40)
		.background(tint.opacity(0.08))
		.clipShape(Capsule())
		.overlay(Capsule().stroke(Color.black.opacity(0.06)))
	}
}
