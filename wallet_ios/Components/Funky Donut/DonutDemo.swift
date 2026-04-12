import SwiftUI

struct ChartDonutDemoView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView(
			data: [
				.init(name: "Rohit Kumar", sales: 14, imgPath: "LargeDP"),
				.init(name: "Verma Sharma", sales: 24, imgPath: "LargeDP"),
				.init(name: "Xaotong Monaco", sales: 90, imgPath: "LargeDP"),
				.init(name: "Obi Wan Kanobi", sales: 32, imgPath: "LargeDP")
			],
			dataMax: 260
		)
	}
}
