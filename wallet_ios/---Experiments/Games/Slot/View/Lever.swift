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
		
		GeometryReader { geo in
			
			let trackHeight = geo.size.height
			let maxOffset = trackHeight - knobSize
			let clampedOffset = min(max(0, dragOffset), maxOffset)
			
			// TRUE visual progress (based on bottom of knob)
			let progress = (clampedOffset + knobSize) / trackHeight
			
			ZStack(alignment: .top) {
				
				// MARK: - Track
				Capsule()
					.fill(Color.white)
					.overlay(
						Capsule()
							.stroke(Color.black.opacity(0.1), lineWidth: 1)
					)
				
				// MARK: - Progress Fill
				VStack(spacing: 0) {
					Color.blue.opacity(0.9)
						.frame(height: trackHeight * progress)
						.clipShape(Capsule())
					Spacer(minLength: 0)
				}
				.clipShape(Capsule())
				
				// MARK: - Knob
				NativeGlassHost(
					tintColor: UIColor(
						red: 0/255,
						green: 111/255,
						blue: 235/255,
						alpha: 0.6
					),
					interactive: true,
					cornerRadius: knobSize / 2
				) {
					Image(systemName: "chevron.down.2")
						.foregroundColor(.white)
				}
				.frame(width: knobSize, height: knobSize)
				.offset(y: clampedOffset)
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							guard !isSpinning else { return }
							
							if !isDragging {
								isDragging = true
								lastTickOffset = 0
								hasLockedIn = false
								
								grabFeedback.prepare()
								tickFeedback.prepare()
								lockFeedback.prepare()
								
								grabFeedback.impactOccurred(intensity: 0.85)
								sounds.playGrab()
							}
							
							dragOffset = min(max(0, value.translation.height), maxOffset)
							
							let knobBottom = dragOffset + knobSize
							let progress = knobBottom / trackHeight
							
							// Tick feedback
							if abs(dragOffset - lastTickOffset) >= tickSpacing {
								tickFeedback.selectionChanged()
								sounds.playTick()
								lastTickOffset = dragOffset
							}
							
							// Threshold logic (based on bottom alignment)
							let overThreshold = progress >= triggerThresholdRatio
							
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
							
							let knobBottom = dragOffset + knobSize
							let progress = knobBottom / trackHeight
							let didTrigger = progress >= triggerThresholdRatio
							
							withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
								dragOffset = 0
							}
							
							if didTrigger {
								releaseFeedback.impactOccurred(intensity: 1.0)
								sounds.playSnap()
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
									spinFeedback.notificationOccurred(.success)
									sounds.playSpinTrigger()
								}
								
								onPulled()
							} else {
								releaseFeedback.impactOccurred(intensity: 0.45)
								sounds.playAbort()
							}
							
							isDragging = false
							hasLockedIn = false
						}
				)
			}
		}
		.frame(width: knobSize, height: reelHeight)
	}
}
