import SwiftUI

struct TabToolbarExample: View {
	var body: some View {
		TabView {
			
			// MARK: - Home (no bottom toolbar)
			NavigationStack {
				Color.red
					.ignoresSafeArea()
					.navigationTitle("Home")
					.toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							Button {
								print("Menu tapped")
							} label: {
								Image(systemName: "line.horizontal.3")
							}
						}
						ToolbarItem(placement: .automatic) {
							Button {
								print("Menu tapped")
							} label: {
								Image(systemName: "line.horizontal.3")
							}
						}
					}
			}
			.tabItem {
				Image(systemName: "house.fill")
				Text("Home")
			}
			
			// MARK: - Alerts (HAS bottom toolbar)
			NavigationStack {
				Color.green
					.ignoresSafeArea()
					.navigationTitle("Alerts")
					.toolbar {
						
						ToolbarItem(placement: .navigationBarTrailing) {
							Button {
								print("Settings tapped")
							} label: {
								Image(systemName: "gearshape.fill")
							}
						}
					}
			}
			.tabItem {
				Image(systemName: "bell.fill")
				Text("Alerts")
			}
			
			// MARK: - Profile (no toolbar)
			NavigationStack {
				Color.blue
					.ignoresSafeArea()
					.navigationTitle("Profile")
			}
			.tabItem {
				Image(systemName: "person.fill")
				Text("Profile")
			}
		}
		.safeAreaInset(edge: .bottom, alignment: .center) {
			Button {
				print("Primary action")
			} label: {
				Image(systemName: "plus")
					.font(.headline)
					.padding(.horizontal, 24)
					.padding(.vertical, 14)
			}
			.background(.thickMaterial)
			.clipShape(Capsule())
			.padding(.bottom, 8)
			.padding(.bottom, 60)
		}
	}
}

#Preview {
	TabToolbarExample()
}
