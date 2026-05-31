import SwiftUI

struct WalletAccountGroupView: View {
	let accounts: [WalletAccount]
	let selectedAccountID: WalletAccount.ID
	let onSelect: (Int) -> Void
	
	var body: some View {
		GeometryReader { proxy in
			let cardWidth = proxy.size.width
			let cardHeight = cardWidth / (85.60 / 53.98)
			
			ZStack(alignment: .top) {
				ForEach(Array(accounts.enumerated()), id: \.element.id) { index, account in
					WalletAccountGroupCard(account: account, cardHeight: cardHeight)
						.offset(y: groupCardY(index))
						.scaleEffect(groupCardScale(index), anchor: .top)
						.zIndex(Double(accounts.count - index))
						.onTapGesture {
							onSelect(index)
						}
				}
			}
			.frame(width: cardWidth, height: cardHeight + 52, alignment: .top)
		}
		.frame(height: 345, alignment: .top)
	}
	
	private func groupCardY(_ index: Int) -> CGFloat {
		let collapsed = [0, -12, -24]
		return CGFloat(collapsed[index])
	}
	
	private func groupCardScale(_ index: Int) -> CGFloat {
		let collapsed = [1.0, 0.96, 0.92]
		return collapsed[index]
	}
}

private struct WalletAccountGroupCard: View {
	let account: WalletAccount
	let cardHeight: CGFloat
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack(alignment: .top) {
				VStack(alignment: .leading, spacing: 8) {
					HStack(alignment: .firstTextBaseline, spacing: 4) {
						Text(account.totalCurrency)
						Text(account.totalAmount)
						Image(systemName: "chevron.right")
							.font(.system(size: 20, weight: .bold))
							.padding(.leading, 2)
					}
					.font(.system(size: 24, weight: .bold))
					.foregroundStyle(.white)
					
					HStack(spacing: 4) {
						Text(account.name)
							.font(.system(size: 16, weight: .semibold))
						Text("·")
						Text(account.badge)
							.textCase(.uppercase)
					}
					.font(.system(size: 14, weight: .semibold))
					.foregroundStyle(.white.opacity(0.78))
				}
				
				Spacer()
				
				HStack(spacing: -7) {
					ForEach(account.wallets.prefix(2)) { wallet in
						Text(wallet.flag)
							.font(.system(size: 17))
							.frame(width: 28, height: 28)
							.background(.white.opacity(0.18))
							.clipShape(Circle())
							.overlay(Circle().stroke(.white.opacity(0.35), lineWidth: 1))
					}
				}
			}
			
			Spacer()
		}
		.padding(18)
		.frame(maxWidth: .infinity)
		.frame(height: cardHeight, alignment: .top)
		.background(account.tint)
		.clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
		.overlay(
			RoundedRectangle(cornerRadius: 36, style: .continuous)
				.stroke(Color(red: 0.97, green: 0.95, blue: 0.92), lineWidth: 1.5)
		)
	}
}
