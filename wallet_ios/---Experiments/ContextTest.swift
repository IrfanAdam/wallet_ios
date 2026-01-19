import SwiftUI

// MARK: - Sample TestChartData
struct TestChartDatum: Identifiable, Hashable {
	let id = UUID()
	let title: String
	let value: Double
}

// MARK: - Observable TestChartContext with multiple sub-contexts
@Observable
final class TestChartContextY {
	var model: TestModel
	var interaction: TestInteraction
	var animation: TestAnimation
	var layout: TestLayout

	init(data: [TestChartDatum], isPseudo: Bool) {
		self.model = TestModel(data: data)
		self.interaction = TestInteraction()
		self.animation = TestAnimation()
		self.layout = TestLayout(isPseudo: isPseudo, geometry: data)
	}

	// MARK: - Sub-contexts
	struct TestModel {
		let data: [TestChartDatum]
		var processedData: [TestChartDatum] = []
		var totalValue: Double { data.reduce(0) { $0 + $1.value } }
	}

	struct TestInteraction {
		var rawSelectedValue: Double? = nil
		var selectedDatum: TestChartDatum? = nil
	}

	struct TestAnimation {
		var animatedData: [TestChartDatum] = []
		var rotationAngle: Angle = .degrees(0)
	}

	struct TestLayout {
		let isPseudo: Bool
		var geometry: [TestChartDatum] = []
	}
}

// MARK: - Parent View
struct TestParentChartViewY: View {
	@State private var contextY = TestChartContextY(
		data: [
			TestChartDatum(title: "Alpha", value: 10),
			TestChartDatum(title: "Beta", value: 20),
			TestChartDatum(title: "Gamma", value: 30)
		],
		isPseudo: true
	)

	var body: some View {
		VStack(spacing: 20) {
			Text("Parent sees selected: \(contextY.interaction.selectedDatum?.title ?? "none")")
				.font(.headline)

			Text("Rotation angle: \(contextY.animation.rotationAngle.degrees, specifier: "%.0f")°")
			Text("Processed count: \(contextY.model.processedData.count)")

			TestChartSubViewY(contextY: contextY)
		}
		.padding()
	}
}

// MARK: - Subview that mutates multiple sub-contexts
struct TestChartSubViewY: View {
	@Bindable var contextY: TestChartContextY

	var body: some View {
		VStack {
			ForEach(contextY.model.data) { datum in
				Button("Select \(datum.title)") {
					// Interaction
					contextY.interaction.selectedDatum = datum
					contextY.interaction.rawSelectedValue = datum.value

					// Animation
					contextY.animation.rotationAngle += .degrees(30)
					contextY.animation.animatedData.append(datum)

					// Model
					contextY.model.processedData.append(datum)
				}
				.padding(5)
				.background(Color.orange.opacity(0.2))
				.cornerRadius(8)
			}
		}
	}
}

// MARK: - Preview
struct TestParentChartViewY_Previews: PreviewProvider {
	static var previews: some View {
		TestParentChartViewY()
	}
}
