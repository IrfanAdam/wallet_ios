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
				.fill(store.config.colors.wheelBG)
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
