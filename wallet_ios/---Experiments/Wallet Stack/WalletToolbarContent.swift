import SwiftUI

struct WalletToolbarContent: ToolbarContent {
	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Image(systemName: "chevron.left")
				.font(.system(size: 18, weight: .semibold))
				.foregroundStyle(Color(red: 0.11, green: 0.18, blue: 0.22))
		}
		
		ToolbarItem(placement: .navigationBarLeading) {
			VStack(alignment: .leading, spacing: 2) {
				Text("Main Account")
					.font(.system(size: 24, weight: .bold))
					.foregroundStyle(Color(red: 0.10, green: 0.16, blue: 0.20))
					.lineLimit(1)
				
				Text("Total CFA 14,0008")
					.font(.system(size: 12, weight: .semibold))
					.foregroundStyle(Color(red: 0.36, green: 0.45, blue: 0.52))
					.lineLimit(1)
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
