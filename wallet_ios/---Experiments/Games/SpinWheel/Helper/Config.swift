import SwiftUI

// MARK: - Spinner Configuration Model

/// Holds all tunable parameters for the spinner.
/// Keeps main view clean and future-proof.
struct RewardSpinnerConfig {
	
	// MARK: Layout
	var segments: Int = 8
	var wheelSize: CGFloat = 240
	
	// MARK: Interaction Feel
	var dragSensitivity: Double = 0.25
	var momentumMultiplier: Double = 8
	var minimumSpinDegrees: Double = 720
	
	// MARK: Animation
	var springMass: Double = 1.2
	var springStiffness: Double = 40
	var springDamping: Double = 8
	var animationDuration: Double = 2.4
}
