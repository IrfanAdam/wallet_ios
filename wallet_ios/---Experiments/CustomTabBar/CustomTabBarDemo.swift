import SwiftUI
import UIKit

// MARK: - Preview / Demo

#Preview {
	DemoTabView()
}

enum CustomTab: String, CaseIterable {
	case home = "Home"
	case search = "Search"
	case notification = "Notifications"
	case profile = "Profile"

	var symbol: String {
		switch self {
			case .home:       return "house"
			case .search:     return "magnifyingglass"
			case .notification: return "bell"
			case .profile:    return "person"
		}
	}

	var index: Int {
		Self.allCases.firstIndex(of: self) ?? 0
	}
}

struct DemoTabView: View {
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			LiquidGlassTabView { index in
				ZStack {
					Color.white
						.ignoresSafeArea()

					ScrollView {
						VStack(alignment: .leading, spacing: 16) {
							ForEach(0..<20) { _ in
								Text("""
Lorem ipsum dolor sit amet,
consectetur adipiscing elit.
Sed do eiusmod tempor incididunt.
""")
							}
						}
						.padding()
					}
				}
			}
			.navigationTitle("Liquid Glass")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
				}
			}
		}
	}
}
