import SwiftUI

struct WalletToolbarContent: ToolbarContent {
	let title: String
	let subtitle: String
	let onBack: () -> Void
	
	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button(action: onBack) {
				Image(systemName: "chevron.left")
					.font(.system(size: 18, weight: .semibold))
					.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.22))
			}
			.buttonStyle(.plain)
		}
		
		ToolbarItem(placement: .navigationBarLeading) {
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.system(size: 24, weight: .bold))
					.foregroundStyle(Color(red: 0.10, green: 0.16, blue: 0.20))
					.lineLimit(1)
				
				Text(subtitle)
					.font(.system(size: 12, weight: .semibold))
					.foregroundStyle(Color(red: 0.36, green: 0.45, blue: 0.52))
					.lineLimit(1)
			}
			.id("\(title)-\(subtitle)")
			.transaction { transaction in
				transaction.animation = nil
			}
			.fixedSize(horizontal: true, vertical: false)
		}
		.sharedBackgroundVisibility(.hidden)
		
		ToolbarItem(placement: .navigationBarTrailing) {
			Image(systemName: "eye")
				.font(.system(size: 16, weight: .semibold))
				.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.22))
		}
	}
}
