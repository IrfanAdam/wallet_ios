import SwiftUI
import Charts

struct SpinnerSegments: View {
	let store: RewardSpinnerStore

	private var geometry: RewardSpinnerGeometry { store.geometry }

	var body: some View {
		GeometryReader { geo in
			let radius = geo.size.width / 2
			let imageRadius = radius * ((1 + geometry.segments.innerRadiusRatio) / 2)

			ZStack {

				SpinnerSegmentChart(store: store)

				SpinnerSegmentImages(
					store: store,
					radius: imageRadius
				)
			}
		}
		.rotationEffect(.degrees(store.anim.rotation))
		.onAppear {
			let base = store.anim.rotation
			withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
				store.anim.rotation = base - 90   // small nudge
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(.spring(response: 0.6, dampingFraction: 0.72)) {
					store.anim.rotation = base
				}
			}
		}
	}
}

struct SpinnerSegmentChart: View {
	
	let store: RewardSpinnerStore
	
	var geometry: RewardSpinnerGeometry { store.geometry }
	var seg: SegmentConfig { geometry.segments }
	var segAnim: RewardSpinnerAnimationConfig.Segments { store.animations.segments }
	
	var body: some View {
		Chart(0..<store.segmentCount, id: \.self) { index in
			let segProps = segmentState(for: index)
			
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
			.spring(
				response:       segAnim.selectionResponse,
				dampingFraction: segAnim.selectionDamping
			),
			value: store.anim.selectedSegmentIndex
		)
	}
}

struct SpinnerSegmentImages: View {
	let store: RewardSpinnerStore
	let radius: CGFloat
	
	var geometry: RewardSpinnerGeometry { store.geometry }
	var seg: SegmentConfig { geometry.segments }
	var colors: BrandColors { store.config.colors }
	
	var body: some View {
		ForEach(0..<store.segmentCount, id: \.self) { index in
			let segProps = segmentState(for: index)
			
			Image(segProps.imageName)
				.resizable()
				.scaledToFill()
				.frame(
					width: segProps.imageSize,
					height: segProps.imageSize
				)
				.background(Circle().fill(colors.brandOrange))
				.clipShape(Circle())
				.overlay(Circle().strokeBorder(colors.circleBorder, lineWidth: 1.5))
				.rotationEffect(.degrees(segProps.imageRotation))
				.scaleEffect(segProps.scale)
				.offset(
					x: segProps.offsetX,
					y: segProps.offsetY
				)
		}
	}
}



