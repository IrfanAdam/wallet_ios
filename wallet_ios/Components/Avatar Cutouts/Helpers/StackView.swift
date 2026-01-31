import SwiftUI

struct AvatarStackView: View {
	let avatars: [AvatarData]
	let shouldCutout: Bool
	
	// internal state
	@State private var circleSize: CGFloat = 0
	@State private var lastIncreaseToken = UUID()
	@State private var isHeightLocked = false
	
	init(
		avatars: [AvatarData],
		shouldCutout: Bool = true
	) {
		self.avatars = avatars
		self.shouldCutout = shouldCutout
	}
	
	var body: some View {
		Group {
			if isHeightLocked {
				contentHStack()
			} else {
				GeometryReader { geo in
					contentHStack()
					.onAppear {
						updateCircleSizeIfNeeded(newHeight: geo.size.height)
					}
					.onChange(of: geo.size.height) { _, newValue in
						updateCircleSizeIfNeeded(newHeight: newValue)
					}
				}
			}
		}
	}
	
	// MARK: - Content Builder
	@ViewBuilder
	private func contentHStack() -> some View {
		HStack {
			AvatarStack(
				avatars: avatars,
				style: makeStyle(for: circleSize),
				shouldCutout: shouldCutout
			)
		}
	}
}

// MARK: - Helper functions outside main struct

private func makeStyle(for circleSize: CGFloat) -> AvatarStyle {
	AvatarStyle(
		strokeWidth: 1.5,
		strokeColor: .blue,
		iconBackgroundColor: .white,
		stackBackgroundColor: .white,
		overlapRatio: 0.25,
		circleSize: circleSize + 1.5 * 2
	)
}

private extension AvatarStackView {
	func updateCircleSizeIfNeeded(newHeight: CGFloat) {
		guard !isHeightLocked else { return }
		
		if newHeight > circleSize {
			circleSize = newHeight
			let token = UUID()
			lastIncreaseToken = token
			
			print("📈 new circle size → \(circleSize)")
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				if lastIncreaseToken == token {
					isHeightLocked = true
					print("🔒 circle size locked at → \(circleSize)")
				}
			}
		}
	}
}
