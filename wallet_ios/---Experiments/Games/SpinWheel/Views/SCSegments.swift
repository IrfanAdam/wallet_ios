import SwiftUI
import Charts

struct SpinnerSegments: View {
	let store: RewardSpinnerStore
	
	private var geometry: Geometry2 {
		store.geometry
	}

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
			withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
				store.engine.physics.rotation = base - 90   // small nudge
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(.spring(response: 0.6, dampingFraction: 0.72)) {
					store.engine.physics.rotation = base
				}
			}
		}
	}
}

struct SpinnerSegmentChart: View {
	
	let store: RewardSpinnerStore
	
	var geometry: Geometry2 { store.geometry }
	var anim: Engine.Anim { store.engine.anim }
	var seg: Geometry2.Segment { geometry.components.segment }
	
	var body: some View {
		Chart(0..<store.segments.count, id: \.self) { index in
			let segProps = segmentState(for: index)

			let s = store.segmentState(for: index)

			SectorMark(
				angle: .value("Segment", 1),
				innerRadius: .ratio(segProps.innerRadius),
				outerRadius: .ratio(segProps.outerRadius),
				angularInset: seg.angularInset
			)
			.cornerRadius(seg.cornerRadius)
			.foregroundStyle(segProps.color)
			.opacity(segProps.opacity)
		}
		.animation(
			anim.spinBounce.animation,
			value: store.engine.model.selectedIndex
		)
	}
}

struct SpinnerSegmentImages: View {
	let store: RewardSpinnerStore
	var geometry: Geometry2 { store.geometry }
	var img: Geometry2.Image { geometry.components.image }
	var colors: SCColors { store.theme.colors }
	
	var body: some View {
		ForEach(0..<store.segments.count, id: \.self) { index in
//			let offset = geometry.imageOffset(for: index)

//			Image(store.segments[index].imageName)
//				.resizable()
//				.scaledToFill()
//				.frame(width: geometry.imageSize, height: geometry.imageSize)
//				.background(Circle().fill(colors.brandOrange))
//				.clipShape(Circle())
//				.overlay(
//					Circle().strokeBorder(colors.wheelBackground, lineWidth: 1.5)
//				)
//				.rotationEffect(.degrees(-store.engine.physics.rotation))
//				.scaleEffect(img.selectedScale)
//				.offset(
//					x: offset.x,
//					y: offset.y
//				)

			let s = store.segmentState(for: index)

			Image(s.imageName)
				.resizable()
				.scaledToFill()
				.frame(width: geometry.imageSize, height: geometry.imageSize)
				.background(Circle().fill(colors.brandOrange))
				.clipShape(Circle())
				.overlay(
					Circle().strokeBorder(colors.wheelBackground, lineWidth: 1.5)
				)
				.rotationEffect(.degrees(s.imageRotation))
				.scaleEffect(s.imageScale)
				.offset(x: s.offset.x, y: s.offset.y)
				.opacity(s.imgOpacity)
		}
	}
}



