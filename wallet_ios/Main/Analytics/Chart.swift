import SwiftUI

struct RoundedDonut_Chart: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVStack {
					ChartDonutDemoView(
						data: [
							.init(name: "Rohit Kumar", sales: 20, imgPath: "LargeDP"),
							.init(name: "Verma Sharma", sales: 24, imgPath: "LargeDP"),
							.init(name: "Xaotong Monaco", sales: 90, imgPath: "LargeDP"),
							.init(name: "Obi Wan Kanobi", sales: 32, imgPath: "LargeDP")
						],
						dataMax: 260
					)
					.frame(width: 320, height: 320)
				}
				.padding(.vertical, 24)
			}
			.navigationTitle("Analytics")
			.navigationBarTitleDisplayMode(.large)
		}.background(
			Color(red: 250/255, green: 248/255, blue: 245/255) // #FAF8F5
		)
	}
}


#Preview {
	RoundedDonut_Chart()
}
