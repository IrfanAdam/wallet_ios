import SwiftUI
import Charts

struct SpinnerSegment: Identifiable {
	let id = UUID()
	let imageName: String
}

// SpinnerSegments.swift

struct SpinnerSegments: View {
	let store: RewardSpinnerStore

	private let innerRadiusRatio: CGFloat = 0.32
	private let imageCircleSize: CGFloat = 48

	var body: some View {
		GeometryReader { geo in
			let size = geo.size.width
			let radius = size / 2
			let segmentAngle = 360.0 / Double(store.segmentCount)
			let imageRadius = radius * ((1 + innerRadiusRatio) / 2)

			ZStack {
				glowLayer
				chartLayer(segmentAngle: segmentAngle)
				imageLayer(radius: imageRadius, segmentAngle: segmentAngle)
			}
		}
	}

	// MARK: - Glow

	private var glowLayer: some View {
		Circle()
			.fill(Color.brandBlue.opacity(0.08))
			.blur(radius: 8)
			.padding(-8)
	}

	// MARK: - Chart

	private func chartLayer(segmentAngle: Double) -> some View {
		Chart(0..<store.segmentCount, id: \.self) { index in
			let isSelected = index == store.selectedSegmentIndex

			SectorMark(
				angle: .value("Segment", 1),
				innerRadius: .ratio(isSelected ? innerRadiusRatio - 0.04 : innerRadiusRatio),
				outerRadius: .ratio(isSelected ? 1.0 : 0.95),
				angularInset: 2
			)
			.cornerRadius(8)
			.foregroundStyle(
				index.isMultiple(of: 2) ? Color.brandBlue : Color.brandSky
			)
			.opacity(store.selectedSegmentIndex == nil || isSelected ? 1.0 : 0.32)
		}
	}

	// MARK: - Images

	private func imageLayer(radius: CGFloat, segmentAngle: Double) -> some View {
		ForEach(0..<store.segmentCount, id: \.self) { index in
			let isSelected = index == store.selectedSegmentIndex
			let midAngle = Double(index) * segmentAngle + (segmentAngle / 2) - 90
			let radians = midAngle * .pi / 180

			Image(store.segments[index].imageName)
				.resizable()
				.scaledToFill()
				.frame(
					width: isActiveImage(isSelected) ? imageCircleSize : 0,
					height: isActiveImage(isSelected) ? imageCircleSize : 0
				)
				.background(Circle().fill(Color.brandOrange))
				.clipShape(Circle())
				.rotationEffect(.degrees(-store.rotation))
				.scaleEffect(isSelected ? 1.15 : 1.0)
				.animation(.spring(response: 0.4), value: store.selectedSegmentIndex)
				.offset(
					x: cos(radians) * radius,
					y: sin(radians) * radius
				)
		}
	}

	// MARK: - Helpers

	private func isActiveImage(_ isSelected: Bool) -> Bool {
		store.selectedSegmentIndex == nil || isSelected
	}
}

extension Color {
	static let brandBlue = Color(red: 0/255,   green: 111/255, blue: 235/255) // vivid blue
	static let brandSky  = Color(red: 82/255,  green: 178/255, blue: 255/255) // lighter complementary blue
	static let brandOrange = Color(red: 235/255, green: 124/255, blue: 0/255)
}
