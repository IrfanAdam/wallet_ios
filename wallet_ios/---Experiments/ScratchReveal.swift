import SwiftUI

#Preview("Scratch Reveal Working") {
	ScratchRevealDemo()
}

struct ScratchRevealDemo: View {
	var body: some View {
		VStack {
			Spacer()

			ScratchRevealCard {
				VStack(spacing: 12) {
					Text("🎉 You Won!")
						.font(.largeTitle.bold())

					Text("Scratch 50% to auto reveal")
						.foregroundStyle(.secondary)
				}
			}
			.frame(width: 300, height: 180)

			Spacer()
		}
		.padding()
		.background(Color.black.opacity(0.08))
	}
}

struct ScratchRevealCard<Content: View>: View {
	let content: Content

	@State private var scratches: [ScratchPoint] = []
	@State private var fullyRevealed = false

	private let revealThreshold: CGFloat = 0.5

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 20)
					.fill(Color.white)
					.overlay(content)
					.shadow(radius: 8)

				if !fullyRevealed {
					ScratchLayerView(
						scratches: $scratches,
						fullyRevealed: $fullyRevealed,
						size: geo.size,
						threshold: revealThreshold
					)
					.transition(.opacity)
				}
			}
			.animation(.easeInOut(duration: 0.35), value: fullyRevealed)
		}
	}
}

struct ScratchPoint {
	let location: CGPoint
	let majorRadius: CGFloat  // Longer axis
	let minorRadius: CGFloat  // Shorter axis
	let angle: CGFloat        // Rotation angle
}

struct ScratchLayerView: UIViewRepresentable {
	@Binding var scratches: [ScratchPoint]
	@Binding var fullyRevealed: Bool
	let size: CGSize
	let threshold: CGFloat

	func makeUIView(context: Context) -> ScratchCanvas {
		let view = ScratchCanvas()
		view.backgroundColor = .clear
		view.scratchDelegate = context.coordinator
		return view
	}

	func updateUIView(_ uiView: ScratchCanvas, context: Context) {
		uiView.scratches = scratches
		uiView.setNeedsDisplay()
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, ScratchDelegate {
		var parent: ScratchLayerView

		init(_ parent: ScratchLayerView) {
			self.parent = parent
		}

		func didAddScratch(_ scratch: ScratchPoint) {
			parent.scratches.append(scratch)

			let scratchedArea = estimateScratchedArea()
			let totalArea = parent.size.width * parent.size.height
			let progress = scratchedArea / totalArea

			if progress >= parent.threshold && !parent.fullyRevealed {
				withAnimation {
					parent.fullyRevealed = true
				}
			}
		}

		private func estimateScratchedArea() -> CGFloat {
			guard !parent.scratches.isEmpty else { return 0 }

			let gridSize: CGFloat = 8  // Smaller grid for better accuracy
			let cols = Int(parent.size.width / gridSize) + 1
			let rows = Int(parent.size.height / gridSize) + 1
			var grid = Set<Int>()

			for scratch in parent.scratches {
				let col = Int(scratch.location.x / gridSize)
				let row = Int(scratch.location.y / gridSize)

				// Check larger area but verify points are actually inside ellipse
				let searchRadius = Int(max(scratch.majorRadius, scratch.minorRadius) / gridSize) + 1

				for r in (row - searchRadius)...(row + searchRadius) {
					for c in (col - searchRadius)...(col + searchRadius) {
						if r >= 0 && r < rows && c >= 0 && c < cols {
							let gridPoint = CGPoint(x: CGFloat(c) * gridSize, y: CGFloat(r) * gridSize)

							// Check if this grid point is actually inside the ellipse
							if isPointInEllipse(point: gridPoint, scratch: scratch) {
								grid.insert(r * cols + c)
							}
						}
					}
				}
			}

			return CGFloat(grid.count) * gridSize * gridSize
		}

		// Helper function to check if a point is inside a rotated ellipse
		private func isPointInEllipse(point: CGPoint, scratch: ScratchPoint) -> Bool {
			// Translate point to ellipse center
			let dx = point.x - scratch.location.x
			let dy = point.y - scratch.location.y

			// Rotate point by negative angle to align with ellipse axes
			let cosAngle = cos(-scratch.angle)
			let sinAngle = sin(-scratch.angle)
			let rotatedX = dx * cosAngle - dy * sinAngle
			let rotatedY = dx * sinAngle + dy * cosAngle

			// Check if inside ellipse using standard equation
			let normalizedX = rotatedX / scratch.majorRadius
			let normalizedY = rotatedY / scratch.minorRadius

			return (normalizedX * normalizedX + normalizedY * normalizedY) <= 1.0
		}
	}
}

protocol ScratchDelegate: AnyObject {
	func didAddScratch(_ scratch: ScratchPoint)
}

class ScratchCanvas: UIView {
	var scratches: [ScratchPoint] = []
	weak var scratchDelegate: ScratchDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		isMultipleTouchEnabled = false
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else { return }

		// Draw scratch surface
		let gradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [
				UIColor.gray.withAlphaComponent(0.9).cgColor,
				UIColor.gray.withAlphaComponent(0.7).cgColor
			] as CFArray,
			locations: [0, 1]
		)!

		let path = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
		context.addPath(path.cgPath)
		context.clip()
		context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0, y: bounds.height), options: [])

		// Cut out scratches as ellipses
		context.setBlendMode(.destinationOut)
		for scratch in scratches {
			context.saveGState()

			// Move to scratch location
			context.translateBy(x: scratch.location.x, y: scratch.location.y)

			// Rotate by touch angle
			context.rotate(by: scratch.angle)

			// Draw ellipse (wider in one direction = finger shape)
			let rect = CGRect(
				x: -scratch.majorRadius,
				y: -scratch.minorRadius,
				width: scratch.majorRadius * 2,
				height: scratch.minorRadius * 2
			)
			context.fillEllipse(in: rect)

			context.restoreGState()
		}
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)

		// Get actual touch dimensions (only works on real device!)
		let majorRadius = max(touch.majorRadius, 25)

		// Minor radius is typically 70-80% of major radius for finger touches
		let minorRadius = majorRadius * 0.75

		// Get touch angle (0 = pointing right, π/2 = pointing down)
		// This represents which way your finger is oriented
		let angle = touch.azimuthAngle(in: self)

		let scratch = ScratchPoint(
			location: location,
			majorRadius: majorRadius,
			minorRadius: minorRadius,
			angle: angle
		)

		scratchDelegate?.didAddScratch(scratch)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		touchesMoved(touches, with: event)
	}
}
