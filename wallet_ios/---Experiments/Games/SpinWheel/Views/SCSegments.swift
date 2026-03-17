import SwiftUI
import Charts

struct SpinnerSegments: View {
	let store: RewardSpinnerStore
	var body: some View {
		GeometryReader { geo in
			ZStack {
				SpinnerSegmentChart(store: store)
				SpinnerSegmentImages(store: store)
			}
		}
		.rotationEffect(.degrees(store.engine.physics.rotation))
		.onAppear {
			let base = store.engine.physics.rotation
			withAnimation(store.engine.anim.spinSmooth.animation) {
				store.engine.physics.rotation = base - 90   // small nudge
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(store.engine.anim.spinBounce.animation) {
					store.engine.physics.rotation = base
				}
			}
		}
	}
}

struct SpinnerSegmentChart: View {
	let store: RewardSpinnerStore
	var body: some View {
		Chart(0..<store.segments.count, id: \.self) { index in
			let s = store.segmentState(for: index)
			SectorMark(
				angle: .value("Segment", 1),
				innerRadius: .ratio(s.innerRadius),
				outerRadius: .ratio(s.outerRadius),
				angularInset: store.geometry.components.segment.angularInset
			)
			.cornerRadius(store.geometry.components.segment.cornerRadius)
			.foregroundStyle(s.color)
			.opacity(s.opacity)
		}
		.animation(
			store.engine.anim.spinBounce.animation,
			value: store.engine.model.selectedIndex
		)
	}
}

struct SpinnerSegmentImages: View {
	let store: RewardSpinnerStore
	var body: some View {
		ForEach(0..<store.segments.count, id: \.self) { index in
			let s = store.segmentState(for: index)
			Image(s.imageName)
				.resizable()
				.scaledToFill()
				.frame(width: store.geometry.imageSize, height: store.geometry.imageSize)
				.background(Circle().fill(store.theme.colors.brandOrange))
				.clipShape(Circle())
				.overlay(
					Circle().strokeBorder(store.theme.colors.wheelBackground, lineWidth: 1.5)
				)
				.rotationEffect(.degrees(s.imageRotation))
				.scaleEffect(s.imageScale)
				.offset(x: s.offset.x, y: s.offset.y)
				.opacity(s.imgOpacity)
		}
	}
}



