import SwiftUI
import AVFoundation
import UIKit

struct SlotLever: View {

	let reelHeight: CGFloat
	let isSpinning: Bool
	let onPulled: () -> Void

	@State private var dragOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var lastTickOffset: CGFloat = 0
	@State private var hasLockedIn = false

	private let knobSize: CGFloat = 36
	private let triggerThresholdRatio: CGFloat = 0.95
	private let tickSpacing: CGFloat = 18

	private let grabFeedback    = UIImpactFeedbackGenerator(style: .medium)
	private let tickFeedback    = UISelectionFeedbackGenerator()
	private let lockFeedback    = UIImpactFeedbackGenerator(style: .heavy)
	private let releaseFeedback = UIImpactFeedbackGenerator(style: .rigid)
	private let spinFeedback    = UINotificationFeedbackGenerator()

	private let sounds = SlotSoundEngine.shared

	var body: some View {

		ZStack(alignment: .top) {

			Capsule()
				.fill(Color.white)
				.strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
				.frame(width: knobSize, height: reelHeight)

			Circle()
				.fill(Color.blue)
				.strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
				.frame(width: knobSize, height: knobSize)
				.offset(y: dragOffset)
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							guard !isSpinning else { return }

							// ── GRAB ──────────────────────────────────────
							if !isDragging {
								isDragging     = true
								lastTickOffset = 0
								hasLockedIn    = false

								grabFeedback.prepare()
								tickFeedback.prepare()
								lockFeedback.prepare()

								grabFeedback.impactOccurred(intensity: 0.85)
								sounds.playGrab()
							}

							let maxOffset = reelHeight - knobSize
							dragOffset    = min(max(0, value.translation.height), maxOffset)

							// ── DRAG TICKS ────────────────────────────────
							if abs(dragOffset - lastTickOffset) >= tickSpacing {
								tickFeedback.selectionChanged()
								sounds.playTick()
								lastTickOffset = dragOffset
							}

							// ── THRESHOLD LOCK-IN ─────────────────────────
							let overThreshold = dragOffset > maxOffset * triggerThresholdRatio
							if overThreshold && !hasLockedIn {
								hasLockedIn = true
								lockFeedback.impactOccurred(intensity: 1.0)
								sounds.playLockIn()
							} else if !overThreshold && hasLockedIn {
								hasLockedIn = false
								releaseFeedback.impactOccurred(intensity: 0.6)
								sounds.playUnlatch()
							}
						}
						.onEnded { _ in
							guard !isSpinning else { return }

							let maxOffset  = reelHeight - knobSize
							let didTrigger = dragOffset > maxOffset * triggerThresholdRatio

							withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
								dragOffset = 0
							}

							if didTrigger {
								// ── RELEASE + SPIN ────────────────────────
								releaseFeedback.impactOccurred(intensity: 1.0)
								sounds.playSnap()

								DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
									spinFeedback.notificationOccurred(.success)
									sounds.playSpinTrigger()
								}

								onPulled()
							} else {
								// ── ABORT ─────────────────────────────────
								releaseFeedback.impactOccurred(intensity: 0.45)
								sounds.playAbort()
							}

							isDragging  = false
							hasLockedIn = false
						}
				)
		}
		.frame(width: 40, height: reelHeight)
	}
}
