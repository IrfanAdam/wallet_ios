import SwiftUI

// MARK: - View

struct SpinnerPointer: View {
	let store: RewardSpinnerStore
	@State var wobble: Double = 0
	@State var lastSegmentIndex: Int = -1
	@State var lastRotation: Double = 0
	
	var ptr: PointerConfig { PointerConfig() }
	
	var body: some View {
		TrianglePointer()
			.fill(store.theme.colors.brandOrange)
			.frame(width: frameSize, height: frameSize)
			.rotationEffect(.degrees(wobble), anchor: wobbleAnchor)
			.rotationEffect(.degrees(pointerRotation))
			.offset(pointerOffset)
			.onChange(of: boundaryIndex) { _, newIndex in
				guard newIndex != lastSegmentIndex else { return }
				lastSegmentIndex = newIndex
				triggerTick()
			}
			.onChange(of: store.engine.physics.rotation) { _, newRotation in
				lastRotation = newRotation
			}
	}
	
	var animStyle : Animation {store.engine.anim.spinSnap.animation}
	
	func triggerTick() {
		TickSoundPlayer.shared.tick()
		withAnimation(animStyle) {
			wobble = -ptr.wobbleDeflection * spinDirection
		}
		withAnimation(animStyle.delay(ptr.wobbleDelay)) {
			wobble = 0
		}
	}
}


// MARK: - Rounded Triangle Shape
struct TrianglePointer: Shape {
	
	var cornerRadius: CGFloat = 4
	
	func path(in rect: CGRect) -> Path {
		let tip   = CGPoint(x: rect.midX, y: rect.maxY)   // points DOWN
		let left  = CGPoint(x: rect.minX, y: rect.minY)
		let right = CGPoint(x: rect.maxX, y: rect.minY)
		
		let radius = min(cornerRadius,
										 rect.width / 2,
										 rect.height / 2)
		
		var path = Path()
		
		// Helper to round between two lines
		func addRoundedCorner(from p1: CGPoint,
													corner: CGPoint,
													to p2: CGPoint) {
			
			let v1 = CGVector(dx: p1.x - corner.x, dy: p1.y - corner.y)
			let v2 = CGVector(dx: p2.x - corner.x, dy: p2.y - corner.y)
			
			let len1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy)
			let len2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy)
			
			let n1 = CGVector(dx: v1.dx / len1, dy: v1.dy / len1)
			let n2 = CGVector(dx: v2.dx / len2, dy: v2.dy / len2)
			
			let start = CGPoint(
				x: corner.x + n1.dx * radius,
				y: corner.y + n1.dy * radius
			)
			
			let end = CGPoint(
				x: corner.x + n2.dx * radius,
				y: corner.y + n2.dy * radius
			)
			
			path.addLine(to: start)
			path.addQuadCurve(to: end, control: corner)
		}
		
		path.move(to: tip)
		
		addRoundedCorner(from: right, corner: tip, to: left)
		addRoundedCorner(from: tip, corner: left, to: right)
		addRoundedCorner(from: left, corner: right, to: tip)
		
		path.closeSubpath()
		
		return path
	}
}

