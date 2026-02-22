import SwiftUI

struct SpinWheelContentView: View {
	@State private var showSpinner = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color(.systemGroupedBackground)
					.ignoresSafeArea()
				
				VStack(spacing: 24) {
					Image(systemName: "gift.circle.fill")
						.font(.system(size: 72))
						.foregroundStyle(Color.brandBlue)
					
					VStack(spacing: 8) {
						Text("Daily Reward")
							.font(.title.bold())
						Text("Spin the wheel for a chance\nto win exclusive prizes")
							.font(.subheadline)
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.center)
					}
					
					Button {
						showSpinner = true
					} label: {
						Label("Spin Now", systemImage: "arrow.clockwise.circle.fill")
							.font(.headline)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 4)
					}
					.buttonStyle(.borderedProminent)
					.tint(.brandBlue)
					.padding(.horizontal, 40)
				}
			}
			.navigationTitle("Rewards")
		}
		.sheet(isPresented: $showSpinner) {
			NavigationStack {
				ZStack {
					Color(.systemGroupedBackground)
						.ignoresSafeArea()
					
					RewardSpinner()
				}
				.navigationTitle("Spin & Win")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button("Done") { showSpinner = false }
					}
				}
			}
			.presentationDetents([.medium])
			.interactiveDismissDisabled()
		}
	}
}

#Preview {
	SpinWheelContentView()
}
