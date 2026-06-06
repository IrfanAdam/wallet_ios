import SwiftUI

struct WalletAccountGroupView: View {
	let accounts: [WalletAccount]
	let selectedAccountID: WalletAccount.ID
	let onSelect: (Int) -> Void
	
	// Transition properties with default values
	var tappedIndex: Int? = nil
	var tappedCardOffset: CGFloat = 0.0
	var tappedCardScale: CGFloat = 1.0
	var otherCardsOpacity: Double = 1.0
	var otherCardsOffsetShift: CGFloat = 0.0
	
	@State private var pressedIndex: Int? = nil
	
	var body: some View {
		GeometryReader { proxy in
			let cardWidth = proxy.size.width
			let cardHeight = cardWidth / (85.60 / 53.98)
			
			ZStack(alignment: .top) {
				ForEach(Array(accounts.enumerated()), id: \.element.id) { index, account in
					let isTapped = (tappedIndex == index)
					let isPressed = (pressedIndex == index)
					
					let baseScale = isTapped ? tappedCardScale : groupCardScale(index)
					let scale = isPressed ? baseScale * 0.95 : baseScale
					
					let baseOffsetY = isTapped ? tappedCardOffset : groupCardY(index)
					let offsetY = isTapped ? baseOffsetY : baseOffsetY + otherCardsOffsetShift
					
					WalletAccountGroupCard(account: account, cardHeight: cardHeight)
						.offset(y: offsetY)
						.scaleEffect(scale, anchor: .top)
						.opacity(isTapped ? 1.0 : otherCardsOpacity)
						.zIndex(isTapped ? 100 : Double(accounts.count - index))
						.gesture(
							DragGesture(minimumDistance: 0)
								.onChanged { value in
									guard tappedIndex == nil else { return }
									let dragDistance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
									if dragDistance > 30 {
										if pressedIndex != nil {
											withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
												pressedIndex = nil
											}
										}
									} else {
										if pressedIndex == nil {
											withAnimation(.spring(response: 0.15, dampingFraction: 0.85)) {
												pressedIndex = index
											}
										}
									}
								}
								.onEnded { value in
									guard tappedIndex == nil else { return }
									if pressedIndex == index {
										withAnimation(.spring(response: 0.15, dampingFraction: 0.85)) {
											pressedIndex = nil
										}
										onSelect(index)
									}
								}
						)
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

struct WalletAccountGroupCard: View {
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
