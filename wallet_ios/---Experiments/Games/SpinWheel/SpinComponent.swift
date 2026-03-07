import SwiftUI
import AVFoundation

// MARK: - Reward Spinner View
struct RewardSpinner: View {
	@State private var store: RewardSpinnerStore

	init(
		segments: [SpinnerSegment] = [],
		config: RewardSpinnerConfig = .init()
	) {
		_store = State(
			initialValue: RewardSpinnerStore(
				segments: segments,
				config: config
			)
		)
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(Color.gray.opacity(0.1))
				.frame(width: store.config.wheelSize, height: store.config.wheelSize)
				.overlay(
					SpinnerSegments(store: store)
				)
				.gesture(
					RewardSpinnerDragGesture(store: store).makeGesture()
				)

			SpinnerPointer(store: store)

			RewardSpinnerMessagingView(store: store)
		}
	}

}
