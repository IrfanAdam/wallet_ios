import SwiftUI

struct WalletTransactionCard: View {
	let title: String
	let subtitle: String
	let date: String
	let amount: String
	let icon: String
	let avatar: String
	
	var body: some View {
		Button {} label: {
			content
		}
		.buttonStyle(WalletTransactionCardButtonStyle())
	}
	
	private var content: some View {
		HStack(alignment: .center, spacing: 12) {
			VStack(alignment: .leading, spacing: 6) {
				Text(title)
					.font(.system(size: 16, weight: .bold))
					.foregroundStyle(Color(red: 0.12, green: 0.17, blue: 0.22))
				Text(subtitle)
					.font(.system(size: 16, weight: .medium))
					.foregroundStyle(Color(red: 0.39, green: 0.49, blue: 0.57))
					.lineLimit(1)
				Text(date)
					.font(.system(size: 15, weight: .medium))
					.foregroundStyle(Color(red: 0.39, green: 0.49, blue: 0.57))
			}
			
			Spacer()
			
			VStack(alignment: .trailing, spacing: 8) {
				Text(amount)
					.font(.system(size: 16, weight: .bold))
					.foregroundStyle(Color(red: 0.12, green: 0.23, blue: 0.36))
				
				HStack(spacing: -7) {
					Image(systemName: icon)
						.font(.system(size: 15, weight: .bold))
						.foregroundStyle(Color(red: 0.45, green: 0.55, blue: 0.61))
						.frame(width: 32, height: 32)
						.background(.white)
						.clipShape(Circle())
					Text(avatar)
						.font(.system(size: 10, weight: .bold))
						.foregroundStyle(.white)
						.frame(width: 36, height: 36)
						.background(Color(red: 0.38, green: 0.55, blue: 0.48))
						.clipShape(Circle())
				}
			}
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 14)
	}
}

private struct WalletTransactionCardButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(configuration.isPressed ? Color(red: 0.98, green: 0.97, blue: 0.95) : .clear)
			)
			.contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.animation(.easeOut(duration: 0.12), value: configuration.isPressed)
	}
}
