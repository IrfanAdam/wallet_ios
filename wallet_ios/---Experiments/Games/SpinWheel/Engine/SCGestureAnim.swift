import SwiftUI

// MARK: - Animations

extension RewardSpinnerDragGesture {
	var snapFailAnimation: Animation {
		.interpolatingSpring(
			mass:      animConfig.failSnapMass,
			stiffness: animConfig.failSnapStiffness,
			damping:   animConfig.failSnapDamping
		)
	}
	var snapSuccessAnimation: Animation {
		.interpolatingSpring(
			mass:      animConfig.successSnapMass,
			stiffness: animConfig.successSnapStiffness,
			damping:   animConfig.successSnapDamping
		)
	}
	var completionAnimation: Animation {
		.spring(
			response:       animConfig.completionResponse,
			dampingFraction: animConfig.completionDamping
		)
	}
	var toastDismissDelay: Double { animConfig.toastDismissDelay }
	var completionDelay:   Double { animConfig.completionDelay }
}
