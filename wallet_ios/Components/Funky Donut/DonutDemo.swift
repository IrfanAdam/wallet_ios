import SwiftUI

struct ChartDonutDemoView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView(
			data: [
				.init(name: "A", sales: 14, imgPath: "LargeDP"),
				.init(name: "B", sales: 24, imgPath: "LargeDP"),
				.init(name: "C", sales: 90, imgPath: "LargeDP"),
				.init(name: "D", sales: 32, imgPath: "LargeDP")
			],
			dataMax: 260
		)
	}
}
