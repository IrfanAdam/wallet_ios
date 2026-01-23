import SwiftUI

struct ChartDonutDemoView_Previews: PreviewProvider {
	static var previews: some View {
		ChartDonutDemoView(
			data: [
				.init(name: "A", sales: 14),
				.init(name: "B", sales: 24),
				.init(name: "C", sales: 62),
				.init(name: "D", sales: 32)
			],
			dataMax: 240
		)
	}
}
