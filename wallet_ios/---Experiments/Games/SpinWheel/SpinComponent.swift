import SwiftUI
import AVFoundation

// MARK: - Reward Spinner View
struct RewardSpinner: View {
	@State var store: RewardSpinnerStore

	init(
		segments: [SpinnerSegment] = [],
		theme: SCTheme = .default
	) {
		_store = State(
			initialValue: RewardSpinnerStore(
				segments: segments,
				theme: theme
			)
		)
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(store.theme.colors.wheelBackground)
				.frame(width: store.geometry.spinWheel.wheelSize, height: store.geometry.spinWheel.wheelSize)
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

struct RewardSpinnerDragGesture {
	let store: RewardSpinnerStore

	func makeGesture() -> some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				store.engine.handleDragChanged(location: value.location)
			}
			.onEnded { value in
				store.engine.handleDragEnded()
			}
	}
}
