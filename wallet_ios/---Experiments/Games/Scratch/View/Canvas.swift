import Foundation

/// Notifies a coordinator whenever the user adds a new scratch stroke.
protocol ScratchDelegate: AnyObject {
	func scratchCanvas(_ canvas: ScratchCanvas, didAdd scratch: ScratchPoint)
}

import UIKit

/// A `UIView` subclass that renders the scratchable silver surface and
/// erases it with a continuous fluid stroke wherever the user's finger travels.
final class ScratchCanvas: UIView {
	
	private var lastTouchPoint: CGPoint?
	private var lastTimestamp: TimeInterval?
	
	// MARK: - Public
	
	weak var scratchDelegate: ScratchDelegate?
	
	// MARK: - Private — rendering
	
	private var offscreenCtx: CGContext?
	private var offscreenImage: CGImage?
	private var needsSnapshot = false
	
	// MARK: - Private — stroke state
	
	private var strokes: [[ScratchPoint]] = []
	private var activeStroke: [ScratchPoint] = []
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	private func configure() {
		isOpaque = false
		backgroundColor = .clear
		isMultipleTouchEnabled = false
		layer.allowsEdgeAntialiasing = true
		
		let absorber = ImmediateGestureRecognizer()
		absorber.cancelsTouchesInView = false
		addGestureRecognizer(absorber)
	}
	
	// MARK: - Layout
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard bounds.size.width > 0, bounds.size.height > 0 else { return }
		let expectedWidth = Int(bounds.width * contentScaleFactor)
		if offscreenCtx == nil || offscreenCtx!.width != expectedWidth {
			rebuildOffscreenContext()
		}
	}
	
	// MARK: - Offscreen context
	
	private func rebuildOffscreenContext() {
		let scale = contentScaleFactor
		let w = Int(bounds.width  * scale)
		let h = Int(bounds.height * scale)
		guard w > 0, h > 0 else { return }
		
		guard let ctx = CGContext(
			data: nil,
			width: w, height: h,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: CGColorSpaceCreateDeviceRGB(),
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		) else { return }
		
		ctx.translateBy(x: 0, y: CGFloat(h))
		ctx.scaleBy(x: scale, y: -scale)
		offscreenCtx = ctx
		
		drawSilverSurface(into: ctx)
		for stroke in strokes    { erase(stroke: stroke, into: ctx) }
		if !activeStroke.isEmpty { erase(stroke: activeStroke, into: ctx) }
		
		commitSnapshot()
	}
	
	// MARK: - Silver surface
	
	private func drawSilverSurface(into ctx: CGContext) {
		let colors: [CGColor] = [
			UIColor(red: 120/255, green: 190/255, blue: 255/255, alpha: 1).cgColor, // highlight
			UIColor(red: 0/255,   green: 111/255, blue: 235/255, alpha: 1).cgColor, // brand blue
			UIColor(red: 0/255,   green: 70/255,  blue: 160/255, alpha: 1).cgColor  // shadow
		]
		guard let gradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: colors as CFArray,
			locations: [0, 0.5, 1.0] as [CGFloat]
		) else { return }
		
		let clipPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
		ctx.addPath(clipPath.cgPath)
		ctx.clip()
		ctx.drawLinearGradient(gradient,
													 start: .zero,
													 end: CGPoint(x: 0, y: bounds.height),
													 options: [])

		drawGiftPattern(into: ctx)
	}

	private func drawGiftPattern(into ctx: CGContext) {
		ctx.saveGState()

		let stripeSpacing: CGFloat = 8
		let diamondSpacing: CGFloat = 14

		let ribbonDark = UIColor(red: 0/255,  green: 90/255,  blue: 200/255, alpha: 1)
		let ribbonLight = UIColor(red: 110/255, green: 200/255, blue: 255/255, alpha: 1)

		// --- 1. Dense diagonal weave ---
		var index = 0
		for x in stride(from: -bounds.height, through: bounds.width, by: stripeSpacing) {

			let color = index.isMultiple(of: 2) ? ribbonDark : ribbonLight
			ctx.setStrokeColor(color.withAlphaComponent(0.20).cgColor)
			ctx.setLineWidth(0.8)

			ctx.move(to: CGPoint(x: x, y: 0))
			ctx.addLine(to: CGPoint(x: x + bounds.height, y: bounds.height))
			ctx.strokePath()

			index += 1
		}

		// --- 2. Cross weave (opposite direction) ---
		ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.10).cgColor)
		ctx.setLineWidth(0.6)

		for x in stride(from: -bounds.height, through: bounds.width, by: stripeSpacing) {
			ctx.move(to: CGPoint(x: x, y: bounds.height))
			ctx.addLine(to: CGPoint(x: x + bounds.height, y: 0))
		}

		ctx.strokePath()

		// --- 3. Dense diamond pattern ---
		ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.18).cgColor)
		ctx.setLineWidth(0.5)

		for x in stride(from: 0, to: bounds.width, by: diamondSpacing) {
			for y in stride(from: 0, to: bounds.height, by: diamondSpacing) {

				let size: CGFloat = 4

				let path = CGMutablePath()
				path.move(to: CGPoint(x: x, y: y - size))
				path.addLine(to: CGPoint(x: x + size, y: y))
				path.addLine(to: CGPoint(x: x, y: y + size))
				path.addLine(to: CGPoint(x: x - size, y: y))
				path.closeSubpath()

				ctx.addPath(path)
				ctx.strokePath()
			}
		}

		// --- 4. Metallic micro sparkles ---
		ctx.setFillColor(UIColor.white.withAlphaComponent(0.25).cgColor)

		let sparkleSpacing: CGFloat = 10

		for x in stride(from: 0, to: bounds.width, by: sparkleSpacing) {
			for y in stride(from: 0, to: bounds.height, by: sparkleSpacing) {

				ctx.fillEllipse(in: CGRect(
					x: x + 1,
					y: y + 1,
					width: 1.5,
					height: 1.5
				))
			}
		}

		ctx.restoreGState()
	}

	// MARK: - Erase helpers
	
	private func erase(stroke: [ScratchPoint], into ctx: CGContext) {
		guard !stroke.isEmpty else { return }
		erasePoints(stroke, bridgeFrom: nil, into: ctx)
	}
	
	private func eraseIncrementally(newPoints: [ScratchPoint], prev: ScratchPoint?) {
		guard let ctx = offscreenCtx, !newPoints.isEmpty else { return }
		erasePoints(newPoints, bridgeFrom: prev, into: ctx)
		needsSnapshot = true
	}
	
	private func erasePoints(_ points: [ScratchPoint],
													 bridgeFrom bridge: ScratchPoint?,
													 into ctx: CGContext) {
		let radius = points.last?.radius ?? 22
		ctx.setBlendMode(.destinationOut)
		ctx.setLineCap(.round)
		ctx.setLineJoin(.round)
		ctx.setLineWidth(radius * 2)
		ctx.setStrokeColor(UIColor.black.cgColor)
		ctx.setFillColor(UIColor.black.cgColor)
		
		let allPoints: [ScratchPoint] = bridge.map { [$0] + points } ?? points
		
		if allPoints.count == 1 {
			let p = allPoints[0]
			ctx.fillEllipse(in: CGRect(x: p.location.x - radius,
																 y: p.location.y - radius,
																 width: radius * 2, height: radius * 2))
		} else {
			let path = CGMutablePath()
			path.move(to: allPoints[0].location)
			for pt in allPoints.dropFirst() { path.addLine(to: pt.location) }
			ctx.addPath(path)
			ctx.strokePath()
		}
	}
	
	// MARK: - Snapshot
	
	private func commitSnapshot() {
		offscreenImage = offscreenCtx?.makeImage()
		needsSnapshot = false
		setNeedsDisplay()
	}
	
	// MARK: - draw
	
	override func draw(_ rect: CGRect) {
		guard let cgImage = offscreenImage,
					let ctx = UIGraphicsGetCurrentContext() else { return }
		ctx.translateBy(x: 0, y: bounds.height)
		ctx.scaleBy(x: 1, y: -1)
		ctx.draw(cgImage, in: bounds)
	}
	
	// MARK: - Reveal animation
	
	/// Plays a radial wipe from `centroid` that expands to cover the entire card,
	/// then calls `completion` once the animation finishes so the caller can
	/// remove this view from the hierarchy.
	///
	/// The mask circle grows from radius 0 → `coverRadius` using a spring-tuned
	/// `CAKeyframeAnimation` so the expansion feels physical rather than linear.
	func playRevealAnimation(centroid: CGPoint, completion: @escaping () -> Void) {
		// ── 1. Build a CAShapeLayer mask ──────────────────────────────────────
		// The mask uses the *inverse* convention: white = visible, black = hidden.
		// We start with a tiny circle at the centroid (almost nothing visible)
		// and animate it to a circle large enough to expose the whole layer.
		// Because we want to REMOVE the silver (reveal what's underneath),
		// we invert: the expanding circle represents the HOLE growing open.
		// We achieve this by masking OUT (using .clear fill inside a full rect).
		
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.fillRule = .evenOdd          // punch-out rule: inner path = hole
		maskLayer.fillColor = UIColor.white.cgColor
		
		// Radius needed to fully cover the layer from the given centroid.
		let coverRadius = coveringRadius(from: centroid)
		
		let startPath = punchPath(centroid: centroid, holeRadius: 0)
		let endPath   = punchPath(centroid: centroid, holeRadius: coverRadius)
		
		maskLayer.path = startPath
		layer.mask = maskLayer
		
		// ── 2. Animate the hole expanding ────────────────────────────────────
		// CAKeyframeAnimation lets us supply a custom timing curve that mimics
		// a spring: fast initial expansion, slight ease-out at the end.
		let anim = CAKeyframeAnimation(keyPath: "path")
		anim.values   = keyframePaths(from: centroid,
																	toRadius: coverRadius,
																	steps: 24)
		anim.duration = 0.52
		anim.timingFunctions = [
			CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.4, 1.0)  // custom spring-ish
		]
		anim.fillMode   = .forwards
		anim.isRemovedOnCompletion = false
		
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			completion()
		}
		maskLayer.add(anim, forKey: "revealWipe")
		maskLayer.path = endPath   // commit final state so it holds after anim
		CATransaction.commit()
	}
	
	// MARK: - Reveal animation helpers
	
	/// Even-odd punch path: a full-bounds rect with a circular hole cut out.
	/// The even-odd fill rule makes the overlap area transparent.
	private func punchPath(centroid: CGPoint, holeRadius: CGFloat) -> CGPath {
		let path = CGMutablePath()
		// Outer rect — fills the entire layer (visible in mask = opaque).
		path.addRect(bounds.insetBy(dx: -2, dy: -2))
		// Inner circle — punched out (visible in mask = transparent).
		// A radius of 0 collapses to a point so the start state is fully opaque.
		if holeRadius > 0 {
			path.addEllipse(in: CGRect(x: centroid.x - holeRadius,
																 y: centroid.y - holeRadius,
																 width:  holeRadius * 2,
																 height: holeRadius * 2))
		}
		return path
	}
	
	/// Generates `steps` intermediate CGPath values for a smooth keyframe animation.
	/// Uses an ease-out power curve so the expansion decelerates naturally.
	private func keyframePaths(from centroid: CGPoint,
														 toRadius: CGFloat,
														 steps: Int) -> [CGPath] {
		(0...steps).map { i in
			let t = CGFloat(i) / CGFloat(steps)
			// Ease-out cubic: fast start, gentle finish
			let eased = 1 - pow(1 - t, 3)
			let r = eased * toRadius
			return punchPath(centroid: centroid, holeRadius: r)
		}
	}
	
	/// Minimum radius of a circle centred at `point` that covers all four corners.
	private func coveringRadius(from point: CGPoint) -> CGFloat {
		let corners: [CGPoint] = [
			.zero,
			CGPoint(x: bounds.width, y: 0),
			CGPoint(x: 0, y: bounds.height),
			CGPoint(x: bounds.width, y: bounds.height),
		]
		return corners.map { corner in
			let dx = corner.x - point.x
			let dy = corner.y - point.y
			return sqrt(dx*dx + dy*dy)
		}.max() ?? max(bounds.width, bounds.height)
	}
	
	// MARK: - Touch handling
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		activeStroke = []
		
		let location = touch.location(in: self)
		lastTouchPoint = location
		lastTimestamp = touch.timestamp
		
		// 🔊 Start continuous scratch synth
		ScratchSoundEngine.shared.start()
		
		let point = makeScratchPoint(from: touch)
		activeStroke.append(point)
		
		eraseIncrementally(newPoints: [point], prev: nil)
		if needsSnapshot { commitSnapshot() }
		
		scratchDelegate?.scratchCanvas(self, didAdd: point)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		let location = touch.location(in: self)
		let timestamp = touch.timestamp
		
		// 🎛 Compute velocity
		if let lastPoint = lastTouchPoint,
			 let lastTime = lastTimestamp {
			
			let dx = location.x - lastPoint.x
			let dy = location.y - lastPoint.y
			let distance = sqrt(dx * dx + dy * dy)
			
			let deltaTime = max(timestamp - lastTime, 0.001)
			let velocity = distance / CGFloat(deltaTime)
			
			// Normalize (tweak 1400 if needed)
			let normalized = min(velocity / 1400, 1.0)
			
			ScratchSoundEngine.shared.update(velocity: normalized)
		}
		
		lastTouchPoint = location
		lastTimestamp = timestamp
		
		// --- your existing scratch logic ---
		
		let samples   = event?.coalescedTouches(for: touch) ?? [touch]
		let newPoints = samples.map { makeScratchPoint(from: $0) }
		let prev      = activeStroke.last
		
		activeStroke.append(contentsOf: newPoints)
		eraseIncrementally(newPoints: newPoints, prev: prev)
		
		if needsSnapshot { commitSnapshot() }
		newPoints.forEach { scratchDelegate?.scratchCanvas(self, didAdd: $0) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// 🔊 Stop synth (it will fade smoothly)
		ScratchSoundEngine.shared.stop()
		
		lastTouchPoint = nil
		lastTimestamp = nil
		
		if !activeStroke.isEmpty {
			strokes.append(activeStroke)
			activeStroke = []
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		ScratchSoundEngine.shared.stop()
		lastTouchPoint = nil
		lastTimestamp = nil
		touchesEnded(touches, with: nil)
	}
	
	// MARK: - Gesture conflict resolution
	
	override func gestureRecognizerShouldBegin(_ gr: UIGestureRecognizer) -> Bool {
		if gr is ImmediateGestureRecognizer { return true }
		return false
	}
	
	// MARK: - Helpers
	
	private func makeScratchPoint(from touch: UITouch) -> ScratchPoint {
		ScratchPoint(location: touch.location(in: self),
								 radius: max(touch.majorRadius, 22))
	}
}

// MARK: - ImmediateGestureRecognizer

private final class ImmediateGestureRecognizer: UIGestureRecognizer {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event); state = .began
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event); state = .changed
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event); state = .ended
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event); state = .cancelled
	}
}
