import SwiftUI

// MARK: - CutoutV2 Models

enum CutoutV2AvatarContent {
	case image(Image)
	case icon(Image)
}

struct CutoutV2AvatarData: Identifiable {
	let id = UUID()
	let content: CutoutV2AvatarContent
	let hasBorder: Bool
	let forceCutout: Bool?
	
	init(
		content: CutoutV2AvatarContent,
		hasBorder: Bool = true,
		forceCutout: Bool? = nil
	) {
		self.content = content
		self.hasBorder = hasBorder
		self.forceCutout = forceCutout
	}
}

struct CutoutV2AvatarStyle {
	var strokeWidth: CGFloat = 1.5
	var strokeColor: Color = .blue
	var iconBackgroundColor: Color = .white
	var stackBackgroundColor: Color = .clear
	var overlapRatio: CGFloat = 0.25
}

// MARK: - CutoutV2 Avatar Stack

struct CutoutV2AvatarStack: View {
	let avatars: [CutoutV2AvatarData]
	let style: CutoutV2AvatarStyle
	let shouldCutout: Bool
	let showBorder: Bool
	let avatarDiameter: CGFloat   // 👈 new
	
	var body: some View {
		HStack(spacing: overlapSpacing) {
			ForEach(avatars.indices, id: \.self) { index in
				let avatar = avatars[index]
				let isLast = index == avatars.count - 1
				let cutout = avatar.forceCutout ?? (shouldCutout && !isLast)
				
				CutoutV2AvatarCircle(
					avatar: avatar,
					style: style,
					isCutout: cutout,
					diameter: avatarDiameter
				)
			}
		}
		.padding(style.strokeWidth)
		.background(backgroundCapsule)
		.clipShape(Capsule())
	}
	
	private var overlapSpacing: CGFloat {
		let cutoutDiameter = avatarDiameter - (style.strokeWidth * 2)
		return -cutoutDiameter  * (style.overlapRatio)
	}
	
	@ViewBuilder
	private var backgroundCapsule: some View {
		if showBorder {
			Capsule()
				.fill(style.stackBackgroundColor)
				.overlay(
					Capsule()
						.inset(by: style.strokeWidth/2)
						.stroke(style.strokeColor, lineWidth: style.strokeWidth)
				)
		}
	}
}

// MARK: - CutoutV2 Avatar Circle

struct CutoutV2AvatarCircle: View {
	let avatar: CutoutV2AvatarData
	let style: CutoutV2AvatarStyle
	let isCutout: Bool
	let diameter: CGFloat
	
	var body: some View {
		ZStack {
			content
			if isCutout {
				cutoutShape
			}
		}
		.frame(width: diameter, height: diameter)
		.compositingGroup()
		.clipShape(Circle())
		.overlay(border)
	}
	
	@ViewBuilder
	private var content: some View {
		switch avatar.content {
		case .image(let image):
			image
				.resizable()
				.scaledToFill()
			
		case .icon(let icon):
			Circle()
				.fill(style.iconBackgroundColor)
				.overlay(
					icon
						.resizable()
						.scaledToFit()
						.padding(10)
						.foregroundColor(style.strokeColor)
				)
		}
	}
	
	private var cutoutShape: some View {
		Circle()
			.frame(width: cutoutDiameter, height: cutoutDiameter)
			.offset(x: cutoutOffset)
			.blendMode(.destinationOut)
	}
	
	private var cutoutDiameter: CGFloat {
		diameter + style.strokeWidth * 2
	}
	
	private var cutoutOffset: CGFloat {
		diameter * (1 - style.overlapRatio) - style.strokeWidth
	}
	
	@ViewBuilder
	private var border: some View {
		if avatar.hasBorder && !isCutout {
			Circle()
				.inset(by: -style.strokeWidth/2)
				.stroke(style.strokeColor, lineWidth: style.strokeWidth)
		}
	}
}

// MARK: - Preview Playground

#Preview("CutoutV2 – Real Cutout") {
	CutoutV2PreviewPlayground()
}

private struct CutoutV2PreviewPlayground: View {
	@State private var cutout = true
	@State private var showBorder = true
	@State private var overlap: CGFloat = 0.25
	@State private var height: CGFloat = 48
	
	var body: some View {
		ZStack {
			Color.green.opacity(0.25) // ← visible through cutout
				.ignoresSafeArea()
			
			VStack(spacing: 24) {
				CutoutV2AvatarStack(
					avatars: demoAvatars,
					style: .init(
						strokeWidth: 2,
						strokeColor: .blue,
						iconBackgroundColor: .white,
						stackBackgroundColor: .gray,
						overlapRatio: overlap
					),
					shouldCutout: cutout,
					showBorder: showBorder,
					avatarDiameter: height   // 👈 same source
				)
				
				controls
			}
			.padding()
		}
	}
	
	private var controls: some View {
		VStack(alignment: .leading, spacing: 12) {
			Toggle("Cutout Enabled", isOn: $cutout)
			Toggle("Show Border", isOn: $showBorder)
			
			HStack {
				Text("Overlap")
				Slider(value: $overlap, in: 0.1...0.5)
			}
			
			HStack {
				Text("Height")
				Slider(value: $height, in: 32...80)
			}
		}
	}
	
	private var demoAvatars: [CutoutV2AvatarData] {
		[
			.init(content: .icon(Image(systemName: "person.fill"))),
			.init(content: .icon(Image(systemName: "creditcard.fill"))),
			.init(content: .icon(Image(systemName: "star.fill")))
		]
	}
}
