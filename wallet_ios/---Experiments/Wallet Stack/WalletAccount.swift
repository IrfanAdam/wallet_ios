import SwiftUI

struct WalletAccount: Identifiable {
	let id = UUID()
	let name: String
	let badge: String
	let totalCurrency: String
	let totalAmount: String
	let tint: Color
	let rewardsCount: Int
	let pendingCount: Int
	let upcomingCount: Int
	let wallets: [Wallet]
	let transactions: [WalletTransaction]
}

struct WalletPanelData {
	let rewardsCount: Int
	let pendingCount: Int
	let upcomingCount: Int
	let transactions: [WalletTransaction]
}

struct WalletTransaction: Identifiable {
	let id = UUID()
	let title: String
	let subtitle: String
	let date: String
	let amount: String
	let icon: String
	let avatar: String
}
