import SwiftUI

struct RewardSpinnerConfig {
	// MARK: Layout
	var wheelSize: CGFloat = 240
	// MARK: - Segments  ← NEW
	
	// MARK: Theme
	var colors = BrandColors()
	
	// MARK: Interaction Feel
	var dragSensitivity: Double = 0.25
	var momentumMultiplier: Double = 8
	var minimumSpinDegrees: Double = 720
	
	// MARK: Animation
	var springMass: Double = 1.2
	var springStiffness: Double = 40
	var springDamping: Double = 8
	var animationDuration: Double = 2.4
	
	// MARK: Physics  ← NEW
	var friction: Double = 0.97
	var stopThreshold: Double = 5
}

struct BrandColors {
	let brandBlue: Color
	let brandSky: Color
	let brandOrange: Color
	
	init(
		brandBlue: Color = Color(red: 0/255, green: 111/255, blue: 235/255),
		brandSky: Color = Color(red: 82/255, green: 178/255, blue: 255/255),
		brandOrange: Color = Color(red: 235/255, green: 124/255, blue: 0/255)
	) {
		self.brandBlue = brandBlue
		self.brandSky = brandSky
		self.brandOrange = brandOrange
	}
}
