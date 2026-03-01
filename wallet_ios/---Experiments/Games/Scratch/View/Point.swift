import CoreGraphics

/// A single point along a scratch stroke, with a circular fingertip radius.
///
/// Using a uniform circle (not a rotated ellipse) matches how a fingertip
/// actually contacts glass — the contact patch is roughly circular, and
/// any perceived elongation in the original code was an artifact of the
/// azimuth-rotation being applied incorrectly.
struct ScratchPoint: Sendable {
	/// Centre of the touch in view coordinates.
	let location: CGPoint
	
	/// Radius of the circular eraser at this point.
	/// Derived from `UITouch.majorRadius`; falls back to a sensible default
	/// in the Simulator where `majorRadius` is always 0.
	let radius: CGFloat
	
	// MARK: - Geometry
	
	/// Returns `true` if `point` lies within the circular footprint.
	func contains(_ point: CGPoint) -> Bool {
		let dx = point.x - location.x
		let dy = point.y - location.y
		return (dx * dx + dy * dy) <= (radius * radius)
	}
}
