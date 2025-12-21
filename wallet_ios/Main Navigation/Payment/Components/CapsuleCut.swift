import SwiftUI

enum AvatarTokens {
	static let size: CGFloat = 36
	static let overlapRatio: CGFloat = 0.2
	
	// All stroke and background concerns centralized here
	static let strokeWidth: CGFloat = 1.5
	static let strokeColor: Color = .blue
	static let iconBackgroundColor: Color = .white.opacity(0.9)
	static let stackBackgroundColor: Color = .white
}

enum AvatarContent {
	case image(Image)
	case icon(Image, backgroundColor: Color = AvatarTokens.iconBackgroundColor)
}

struct AvatarData: Identifiable {
	let id = UUID()
	let content: AvatarContent
	let hasBorder: Bool
	
	init(content: AvatarContent, hasBorder: Bool = true) {
		self.content = content
		self.hasBorder = hasBorder
	}
}

@ViewBuilder
func AvatarCircle(
	size: CGFloat = AvatarTokens.size,
	image: Image? = nil,
	icon: Image? = nil,
	isCutout: Bool = false,
	hasBorder: Bool = true
) -> some View {
	
	let diameter = size
	let overlap = AvatarTokens.overlapRatio
	let strokeWidth = AvatarTokens.strokeWidth
	
	let cutoutDiameter = diameter + (strokeWidth * 2)
	let cutoutOffset = (cutoutDiameter * (1 - overlap) - (strokeWidth * 2))
	
	ZStack {
		if let image {
			image
				.resizable()
				.scaledToFill()
				.frame(width: diameter, height: diameter)
				.clipped()
			
		} else if let icon {
			ZStack {
				Circle().fill(AvatarTokens.iconBackgroundColor)
				
				icon
					.renderingMode(.template)
					.resizable()
					.scaledToFit()
					.padding(diameter * 0.2)
					.foregroundColor(Color.blue)
			}
		}
		
		if isCutout {
			Circle()
				.frame(width: cutoutDiameter, height: cutoutDiameter)
				.blendMode(.destinationOut)
				.offset(x: cutoutOffset)
		}
	}
	.compositingGroup()
	.frame(width: diameter, height: diameter)
	.clipShape(Circle())
	.overlay(
		Group {
			if !isCutout && hasBorder {
				Circle()
					.stroke(AvatarTokens.strokeColor, lineWidth: strokeWidth)
			}
		}
	)
}

struct AvatarStack: View {
	let avatars: [AvatarData]
	let avatarSize: CGFloat
	let showBackground: Bool
	
	init(
		avatars: [AvatarData],
		avatarSize: CGFloat = 34,
		showBackground: Bool = false
	) {
		self.avatars = avatars
		self.avatarSize = avatarSize
		self.showBackground = showBackground
	}
	
	var body: some View {
		HStack(spacing: -(avatarSize * AvatarTokens.overlapRatio)) {
			ForEach(Array(avatars.enumerated()), id: \.element.id) { index, avatar in
				let isLast = index == avatars.count - 1
				
				switch avatar.content {
				case .image(let image):
					AvatarCircle(
						size: avatarSize,
						image: image,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder
					)
					
				case .icon(let icon, _):
					AvatarCircle(
						size: avatarSize,
						icon: icon,
						isCutout: !isLast,
						hasBorder: avatar.hasBorder
					)
				}
			}
		}
		.padding(2) // Inner padding for stroke
		.background {
			if showBackground {
				RoundedRectangle(cornerRadius: 32, style: .continuous)
					.fill(AvatarTokens.stackBackgroundColor)
			}
		}
		.overlay(
			Capsule()
				.strokeBorder(AvatarTokens.strokeColor, lineWidth: AvatarTokens.strokeWidth)
		)
		.drawingGroup() // Single compositing operation for the entire stack
	}
}

struct CombinedStacksView: View {
	
	private let avatars: [AvatarData] = [
		AvatarData(content: .image(Image("LargeDP"))),
		AvatarData(content: .icon(Image("ph_credit-card-bold")), hasBorder: false)
	]
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.mint.ignoresSafeArea()
				
				AvatarStack(
					avatars: avatars,
					avatarSize: AvatarTokens.size,
					showBackground: false
				)
			}
		}
	}
}

#Preview {
	CombinedStacksView()
}
