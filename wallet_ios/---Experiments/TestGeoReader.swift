import SwiftUI

struct FillHeightHugWidthView: View {
	var body: some View {
		HStack { // Or VStack if you want horizontal placement
			GeometryReader { geo in
				VStack {
					Text("Hello, world!")
						.padding()
						.background(Color.red)

					Text("This view fills height but hugs width")
						.padding()
						.background(Color.orange)
				}
				.frame(width: geo.size.width) // optional if content width should match container
			}
			.frame(maxHeight: .infinity) // Fill the vertical space
			.fixedSize(horizontal: true, vertical: false) // Hug content width
			.background(Color.red.opacity(0.3)) // just for visualization
		}
		.frame(maxHeight: .infinity) // Parent allows full height
		.background(Color.blue.opacity(0.2))
	}
}

struct FillHeightHugWidthView_Previews: PreviewProvider {
	static var previews: some View {
		FillHeightHugWidthView()
			.frame(height: 240) // For demo
	}
}
