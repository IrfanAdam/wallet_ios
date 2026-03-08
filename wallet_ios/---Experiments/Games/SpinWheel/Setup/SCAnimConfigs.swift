import SwiftUI

struct RewardSpinnerAnimationConfig {
	struct Spin {
		var failSnapMass: Double        = 0.6
		var failSnapStiffness: Double   = 140
		var failSnapDamping: Double     = 16
		
		var successSnapMass: Double     = 0.6
		var successSnapStiffness: Double = 120
		var successSnapDamping: Double   = 14
		
		var completionResponse: Double  = 0.4
		var completionDamping: Double   = 0.6
		
		var completionDelay: Double     = 0.3
		var toastDismissDelay: Double   = 1.4
	}
	
	struct Pointer {
		var wobbleMass: Double          = 0.3
		var wobbleStiffness: Double     = 300
		var wobbleDamping: Double       = 6
		
		var returnStiffness: Double     = 200
		var returnDamping: Double       = 8
	}
	
	struct Messaging {
		var scaleTransition: CGFloat    = 0.85
		var dismissResponse: Double     = 0.4
		var dismissDamping: Double      = 0.7
	}
	
	struct Segments {
		var selectionResponse: Double   = 0.4
		var selectionDamping: Double    = 1.0
	}
	
	var spin      = Spin()
	var pointer   = Pointer()
	var messaging = Messaging()
	var segments  = Segments()
}
