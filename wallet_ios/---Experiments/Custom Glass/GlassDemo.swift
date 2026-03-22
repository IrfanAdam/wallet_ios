import SwiftUI

#Preview {
	ZStack {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				ForEach(0..<40, id: \.self) { i in
					Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Line \(i)")
						.font(.system(size: 18, weight: .medium))
				}
			}
			.padding(24)
		}.background(.white)

		VStack {
			SwipeToUnlock(
				capSize: CGSize(width: 56, height: 52),
				trackHeight: 44
			) {
				print("Unlocked")
			}
			.padding(32)

			GlassEffectContainer(spacing: 40.0) {
				HStack(spacing: 48.0) {
					Image(systemName: "scribble.variable")
						.frame(width: 80.0, height: 80.0)
						.font(.system(size: 36))
						.glassEffect(.regular.interactive())


					Image(systemName: "eraser.fill")
						.frame(width: 60.0, height: 60.0)
						.font(.system(size: 32))
						.glassEffect(.regular.interactive().tint(Color.blue))
						.foregroundStyle(Color.white)
						.offset(x: -40.0, y: 0.0)
				}
			}

			CustomGlass()
		}
	}
}
