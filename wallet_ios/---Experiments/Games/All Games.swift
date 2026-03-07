import SwiftUI

#Preview {
	RewardGames()
}

struct RewardGames: View {
	@State private var showSpinner = false
	@State private var showSlot = false
	@State private var showScratch = false
	@State private var showQuiz = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color(.systemGroupedBackground)
					.ignoresSafeArea()
				
				VStack(spacing: 16) {
					Image(systemName: "gift.circle.fill")
						.font(.system(size: 72))
						.foregroundStyle(Color.blue)

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
						tint: .blue
					) {
						showSpinner = true
					}
					
					RewardGameButton(
						title: "Slot Machine",
						systemImage: "rectangle.3.group.fill",
						tint: .blue
					) {
						showSlot = true
					}
					
					RewardGameButton(
						title: "Scratch Reveal",
						systemImage: "sparkles.rectangle.stack.fill",
						tint: .blue
					) {
						showScratch = true
					}
					
					RewardGameButton(
						title: "Quiz",
						systemImage: "questionmark.circle.fill",
						tint: .blue
					) {
						showQuiz = true
					}
				}
			}
			.navigationTitle("Rewards")
		}
		.sheet(isPresented: $showSpinner) {
			RewardSheetContainer(title: "Spin Wheel") {
				RewardSpinnerDemo()
			}
		}
		.sheet(isPresented: $showSlot) {
			RewardSheetContainer(title: "Slot Machine") {
				SlotMachineView()
			}
		}
		.sheet(isPresented: $showScratch) {
			RewardSheetContainer(title: "Scratch Reveal") {
				ScratchRevealCard(revealThreshold: 0.36) {
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
		}
		.sheet(isPresented: $showQuiz) {
			RewardSheetContainer(title: "Answer to Win") {
				QuizDemoView()
			}
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
			.padding(.vertical, 4)
		}
		.buttonStyle(.borderedProminent)
		.tint(tint)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.padding(.horizontal, 40)
	}
}

struct RewardSheetContainer<Content: View>: View {
	
	let title: String
	let detents: Set<PresentationDetent>
	let content: Content
	
	@Environment(\.dismiss) private var dismiss
	
	init(
		title: String,
		detents: Set<PresentationDetent> = [.medium],
		@ViewBuilder content: () -> Content
	) {
		self.title = title
		self.detents = detents
		self.content = content()
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color(.systemGroupedBackground)
					.opacity(0.001)
					.ignoresSafeArea()
				
				content
			}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text(title)
						.font(.headline)
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
					}
					.buttonStyle(.plain)
				}
			}
			.toolbarTitleDisplayMode(.inline)
		}
		.presentationDetents(detents)
		.presentationDragIndicator(.hidden)
		.interactiveDismissDisabled()
	}
}
