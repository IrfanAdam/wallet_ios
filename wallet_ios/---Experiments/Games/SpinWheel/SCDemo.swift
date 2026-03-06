import SwiftUI

struct RewardSpinnerDemo: View {
	let demoSegments: [SpinnerSegment] = [
		.init(imageName: "Dineout"),
		.init(imageName: "Bike"),
		.init(imageName: "Hotel"),
		.init(imageName: "Car"),
		.init(imageName: "Vacay"),
		.init(imageName: "Party")
	]

	var body: some View {
		RewardSpinner(segments: demoSegments)
	}
}

#Preview {
	RewardSpinnerDemo()
}
