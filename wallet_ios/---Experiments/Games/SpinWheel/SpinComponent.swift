import SwiftUI
import AVFoundation

// MARK: - Reward Spinner View

enum SpinnerState {
	case idle
	case spinning
	case completed(segmentIndex: Int)
}

extension SpinnerState: Equatable {
	var isCompleted: Bool {
		if case .completed = self { return true }
		return false
	}
}

struct RewardSpinner: View {

	@State private var store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry {
		RewardSpinnerGeometry(
			config: store.config,
			segmentCount: store.segmentCount
		)
	}

	init(config: RewardSpinnerConfig = .init()) {
		_store = State(initialValue: RewardSpinnerStore(
			segments: [
				.init(imageName: "Dineout"),
				.init(imageName: "Bike"),
				.init(imageName: "Hotel"),
				.init(imageName: "Car"),
				.init(imageName: "Vacay"),
				.init(imageName: "Party")
			],
			config: config
		))
	}

	var body: some View {
		ZStack {
			wheelLayer
			pointerLayer
			messagingLayer
		}
	}

	// MARK: - Layers

	private var wheelLayer: some View {
		let config = store.config
		return Circle()
			.fill(Color.gray.opacity(0.1))
			.overlay(
				SpinnerSegments(store: store)
			)
			.frame(width: config.wheelSize, height: config.wheelSize)
			.rotationEffect(.degrees(store.rotation))
			.gesture(
				RewardSpinnerDragGesture(store: store).makeGesture()
			)
	}

	private var pointerLayer: some View {
		let offset = geometry.pointerOffset()

		return SpinnerPointer(
			rotation: store.rotation,
			segmentCount: store.segmentCount
		)
		.rotationEffect(.degrees(geometry.pointerRotation))
		.offset(offset)
	}

	private var messagingLayer: some View {
		RewardSpinnerMessagingView(store: store)
	}
}
