import SwiftUI

struct RoundedDonut_Chart: View {
	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVStack {
					ChartDonutDemoView(
						data: [
							.init(name: "A", sales: 20, imgPath: "LargeDP"),
							.init(name: "B", sales: 15, imgPath: "LargeDP"),
							.init(name: "C", sales: 40, imgPath: "LargeDP"),
							.init(name: "D", sales: 25, imgPath: "LargeDP")
						],
						dataMax: 320
					)
					.frame(width: 360, height: 360)
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
