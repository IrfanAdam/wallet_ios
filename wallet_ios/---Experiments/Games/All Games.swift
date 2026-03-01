import SwiftUI

#Preview {
	RewardGames()
}

struct RewardGames: View {
	@State private var showSpinner = false
	@State private var showSlot = false
	@State private var showScratch = false
	
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
					
					RewardGameButton(
						title: "Spin Wheel",
						systemImage: "circle.dotted",
						tint: .brandBlue
					) {
						showSpinner = true
					}
					
					RewardGameButton(
						title: "Slot Machine",
						systemImage: "rectangle.3.group.fill",
						tint: .brandBlue
					) {
						showSlot = true
					}
					
					RewardGameButton(
						title: "Scratch Reveal",
						systemImage: "sparkles.rectangle.stack.fill",
						tint: .brandBlue
					) {
						showScratch = true
					}
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
				.toolbar {
					ToolbarItem(placement: .title) {
						Text("Slot Machine")
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button(action: {showSpinner = false}) {
							Image(systemName: "xmark")
						}
						.buttonStyle(.plain)
					}
				}
				.toolbarTitleDisplayMode(.inlineLarge)
			}
			.presentationDetents([.medium])
			.interactiveDismissDisabled()
		}
		.sheet(isPresented: $showSlot) {
			NavigationStack {
				ZStack {
					Color(.systemGroupedBackground)
						.ignoresSafeArea()
					
					SlotMachineView()
				}
				.toolbar {
					ToolbarItem(placement: .title) {
						Text("Slot Machine")
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button(action: {showSlot = false}) {
							Image(systemName: "xmark")
						}
						.buttonStyle(.plain)
					}
				}
				.toolbarTitleDisplayMode(.inlineLarge)
			}
			.presentationDetents([.medium])
			.interactiveDismissDisabled()
		}
		.sheet(isPresented: $showScratch) {
			NavigationStack {
				ZStack {
					Color(.systemGroupedBackground)
						.ignoresSafeArea()

					ScratchRevealCard(revealThreshold: 0.5) {
						VStack(spacing: 12) {
							Text("🎉 You Won!")
								.font(.largeTitle.bold())
							
							Text("Scratch 50% to reveal")
								.font(.subheadline)
								.foregroundStyle(.secondary)
						}
					}
					.frame(width: 300, height: 180)
				}
				.toolbar {
					ToolbarItem(placement: .title) {
						Text("Scratch Reveal")
					}
					ToolbarItem(placement: .topBarTrailing) {
						Button(action: {showScratch = false}) {
							Image(systemName: "xmark")
						}
						.buttonStyle(.plain)
					}
				}
				.toolbarTitleDisplayMode(.inlineLarge)
			}
			.presentationDetents([.medium])
			.presentationDragIndicator(.hidden)   // hide grabber
			.interactiveDismissDisabled()
		}
	}
}


struct RewardGameButton: View {
	
	let title: String
	let systemImage: String
	let tint: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack(spacing: 12) {
				Image(systemName: systemImage)
					.font(.system(size: 20, weight: .semibold))
				
				Text(title)
					.font(.headline)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 8)
		}
		.buttonStyle(.borderedProminent)
		.tint(tint)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.padding(.horizontal, 40)
	}
}
