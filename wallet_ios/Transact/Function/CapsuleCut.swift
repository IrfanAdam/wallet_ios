import SwiftUI

// MARK: - Global Constants for Sizing

let avatarSize: CGFloat = 40.0
// The overlap amount when stacking two avatar views together
let overlapSpacing: CGFloat = -16.0
// The size needed for the cutout circle to fully cover the avatar area
let microGap: CGFloat = 3.2
let cutoutCircleSize: CGFloat = avatarSize + microGap


// A reusable view that implements the CUTOUT effect, using global constants
struct CutoutAvatarView: View {
	var body: some View {
		// Use a ZStack to manage internal layering for the cutout
		ZStack {
			Image("LargeDP")                 // must exist in Assets.xcassets
				.resizable()
				.scaledToFill()
				.frame(width: avatarSize, height: avatarSize)
				.clipShape(Circle()) // Clip to a circle for a better visual match

			// The 'cutout' shape placed on top, but blended out
			Circle()
				.frame(width: cutoutCircleSize, height: cutoutCircleSize)
				.blendMode(.destinationOut)
			// Offset the cutout circle to align with where the next avatar starts
				.offset(x: -overlapSpacing + microGap)
		}
		.compositingGroup() // Groups the blend mode operation
		.frame(width: avatarSize, height: avatarSize)
	}
}

// A view for the final avatar in the sequence that includes the outer stroke
struct StrokedAvatarView: View {
	var body: some View {
		ZStack {
			Image("LargeDP")
				.resizable()
				.scaledToFill()
				.frame(width: avatarSize, height: avatarSize)
				.clipShape(Circle())

		}
		.compositingGroup()
		.frame(width: avatarSize, height: avatarSize)
		// Add the white stroke to the final circle shape
		.overlay(
			Circle()
				.stroke(Color.white, lineWidth: 1.5)
		)
	}
}

// A view for the final avatar in the sequence that includes the outer stroke
struct StrokedIconView: View {
	var body: some View {
		ZStack {
			Circle()
				.fill(Color.white)
				.frame(width: avatarSize, height: avatarSize)
			Image("ph_credit-card")
				.resizable()
				.scaledToFill()
				.frame(width: avatarSize-8, height: avatarSize-8)
				.clipShape(Circle())

		}
		.foregroundColor(Color.black)
		.compositingGroup()
		.frame(width: avatarSize, height: avatarSize)
		// Add the white stroke to the final circle shape
	}
}


// This struct enables the Xcode Canvas Preview
struct CombinedStacksView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ZStack {
				Color.mint.ignoresSafeArea()

				HStack(spacing: overlapSpacing) {
					CutoutAvatarView()
					CutoutAvatarView()
					StrokedIconView()
				}
				.overlay(
					Capsule()
						.stroke(Color.white, lineWidth: 2)
				)
				.compositingGroup()
			}
		}
	}
}
