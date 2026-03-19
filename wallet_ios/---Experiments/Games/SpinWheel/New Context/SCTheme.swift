import SwiftUI

struct SCTheme {
	var colors: SCColors

	static let `default` = SCTheme(colors: .init())
}

struct SCColors {
	var wheelBackground = Color.white.opacity(0.48)
	var content         = Color.black
	var brandBlue       = Color(red: 0/255, green: 111/255, blue: 235/255)
	var brandSky        = Color(red: 82/255, green: 178/255, blue: 255/255)
	var brandOrange     = Color(red: 235/255, green: 124/255, blue: 0/255)
}

enum SpinnerAnimationStyle {
	case snappy
	case smooth
	case bouncy
	case quick

	var animation: Animation {
		switch self {
		case .snappy:
			return .interpolatingSpring(mass: 0.5, stiffness: 180, damping: 16)
		case .smooth:
			return .spring(response: 0.5, dampingFraction: 0.9)
		case .bouncy:
			return .spring(response: 0.4, dampingFraction: 0.6)
		case .quick:
			return .easeOut(duration: 0.2)
		}
	}
}

