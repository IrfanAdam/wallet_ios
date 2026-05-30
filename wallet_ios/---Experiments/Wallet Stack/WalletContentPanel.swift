import SwiftUI

struct WalletContentPanel: View {
	let progress: CGFloat
	
	var body: some View {
		VStack(spacing: 0) {
			Capsule()
				.fill(Color.black.opacity(0.12))
				.frame(width: 62, height: 4)
				.padding(.top, 4)
				.opacity(progress > 0.15 ? 1 : 0)

			primaryActions.padding(.top, 16)

				
			statusChips
				.padding(.top, 16)
			
			recents
				.padding(.top, 18)
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
			WalletStatusChip(icon: "gift", text: "3", tint: .green)
			WalletStatusChip(icon: "hourglass", text: "2 Pending", tint: .orange)
			WalletStatusChip(icon: "clock.badge", text: "12 Upcoming", tint: .blue)
			Spacer(minLength: 0)
		}
		.padding(.horizontal, 16)
	}
	
	private var recents: some View {
		VStack(spacing: 0) {
			WalletTransactionCard(title: "Split Payment Recieved", subtitle: "from Dilip Kumar", date: "7 Dec, 04:00pm", amount: "INR 65", icon: "arrow.down.left", avatar: "DK")
			Divider().padding(.leading, 16)
			
			WalletTransactionCard(title: "Added Money", subtitle: "to *********7890", date: "7 Dec, 04:00pm", amount: "+ INR 330", icon: "plus", avatar: "AM")
			Divider().padding(.leading, 16)
			
			WalletTransactionCard(title: "Transfered to Bank", subtitle: "from Oluwaseun Oluwatoyin Adedeji", date: "7 Dec, 04:00pm", amount: "- INR 10,310", icon: "building.columns", avatar: "TB")
			Divider().padding(.leading, 16)
			
			WalletTransactionCard(title: "Top Up", subtitle: "to Airtel - 12312123", date: "7 Dec, 04:00pm", amount: "- INR 260", icon: "iphone", avatar: "AT")
			
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
