import SwiftUI

enum FlowTone {
	case primary
	case secondary

	var color: Color {
		switch self {
		case .primary:
			return Color(red: 0.11, green: 0.18, blue: 0.23)
		case .secondary:
			return Color(red: 0.4, green: 0.47, blue: 0.53)
		}
	}
}

enum FlowItem {
	case text(String, tone: FlowTone)
	case pill(String)
}
