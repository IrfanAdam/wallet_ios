import SwiftUI

// RewardSpinnerMessagingView.swift

struct RewardSpinnerMessagingView: View {

	let store: RewardSpinnerStore

	var body: some View {
		ZStack {
			if case .completed = store.spinnerState {
				panelContainer { completionContent }
					.transition(.scale(scale: 0.85).combined(with: .opacity))
			} else if store.showToast {
				panelContainer { toastContent }
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
	}

	// MARK: - Shared Container

	private func panelContainer<Content: View>(
		@ViewBuilder content: () -> Content
	) -> some View {
		VStack(spacing: 16) { content() }
			.padding(.horizontal, 40)
			.offset(y: store.config.wheelSize / 2 + 60)
	}

	// MARK: - Toast Content

	private var toastContent: some View {
		Text(store.toastMessage)
			.font(.subheadline.weight(.semibold))
			.multilineTextAlignment(.center)
			.frame(maxWidth: .infinity)
			.padding(.vertical, 12)
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 14))
	}

	// MARK: - Completion Content

	private var completionContent: some View {
		HStack {
			Button {
				withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
					store.selectedSegmentIndex = nil
					store.spinnerState = .idle
					store.toastMessage = ""
				}
			} label: {
				Label("Spin Again", systemImage: "arrow.clockwise")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.bordered)

			Button { revealPrize() } label: {
				Label("Rewards", systemImage: "dollarsign.circle.fill")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.tint(.brandBlue)
		}
	}

	// MARK: - Actions

	private func revealPrize() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
	}
}
