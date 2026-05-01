import os
import UIKit

@available(iOS 26.0, *)
final class TabBarSegmentedControl: UISegmentedControl {

	private var originalIndex: Int?
	private weak var cachedIndicatorView: UIView?

	private var contentViews: [TabItemContentView] = []
	private var accentViews: [TabItemContentView] = []

	private var displayLink: CADisplayLink?
	private var displayProxy: TabBarDisplayLinkProxy?

	private var lastIndicatorRect: CGRect = .zero
	private var stableFrameCount = 0
	private var didLogFallback = false

	private static let baseTag = 7_777
	private static let accentTag = 7_778
	private static let stableFrames = 3

	var activeTintColor: UIColor = .tintColor { didSet { updateColors() } }
	var inactiveTintColor: UIColor = .label { didSet { updateColors() } }
	var onReselect: ((Int) -> Void)?

	override init(items: [Any]?) {
		super.init(items: items)
		accessibilityTraits = .tabBar
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError() }

	override func layoutSubviews() {
		super.layoutSubviews()
		wakeDisplayLink()
		hideImages()
		hideLabels(in: self)
		injectViewsIfNeeded()
		updateColors()
	}

	override func didMoveToWindow() {
		super.didMoveToWindow()
		window == nil ? stopDisplayLink() : startDisplayLink()
	}

	override func didAddSubview(_ subview: UIView) {
		super.didAddSubview(subview)
		hideLabels(in: subview)
	}

	func configureContentViews(
		_ base: [TabItemContentView],
		accentViews: [TabItemContentView]
	) {
		cachedIndicatorView = nil

		for segment in segments() {
			segment.viewWithTag(Self.baseTag)?.removeFromSuperview()
			segment.viewWithTag(Self.accentTag)?.removeFromSuperview()
		}

		contentViews = base
		self.accentViews = accentViews
		setNeedsLayout()
	}

	private func injectViewsIfNeeded() {
		let segs = segments()
		guard segs.count == contentViews.count,
					segs.count == accentViews.count else { return }

		for (i, segment) in segs.enumerated() {
			install(contentViews[i], tag: Self.baseTag, in: segment, masked: false)
			install(accentViews[i], tag: Self.accentTag, in: segment, masked: true)
		}
	}

	private func install(
		_ view: TabItemContentView,
		tag: Int,
		in parent: UIView,
		masked: Bool
	) {
		guard parent.viewWithTag(tag) == nil else { return }

		view.tag = tag
		view.translatesAutoresizingMaskIntoConstraints = false
		parent.addSubview(view)

		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
			view.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
		])

		if masked { view.layer.mask = CAShapeLayer() }
	}

	private func updateColors() {
		contentViews.forEach { $0.tintColor = inactiveTintColor }
		accentViews.forEach { $0.tintColor = activeTintColor }
	}

	private func segments() -> [UIView] {
		descendants(of: self)
			.filter { String(describing: type(of: $0)) == "UISegment" }
			.sorted { $0.frame.minX < $1.frame.minX }
	}

	private func descendants(of root: UIView) -> [UIView] {
		root.subviews + root.subviews.flatMap(descendants)
	}

	private func hideLabels(in view: UIView) {
		if let label = view as? UILabel,
			 label.superview?.tag != Self.baseTag,
			 label.superview?.tag != Self.accentTag {
			label.isHidden = true
		}

		view.subviews.forEach(hideLabels)
	}

	private func hideImages() {
		subviews.compactMap { $0 as? UIImageView }.forEach { $0.alpha = 0 }
	}

	private func startDisplayLink() {
		guard displayLink == nil else { return }

		let proxy = TabBarDisplayLinkProxy(control: self)
		displayProxy = proxy

		let link = CADisplayLink(
			target: proxy,
			selector: #selector(TabBarDisplayLinkProxy.tick)
		)

		link.add(to: .main, forMode: .common)
		displayLink = link
	}

	private func stopDisplayLink() {
		displayLink?.invalidate()
		displayLink = nil
		displayProxy = nil
	}

	private func wakeDisplayLink() {
		displayLink?.isPaused = false
		stableFrameCount = 0
	}

	private func indicatorView() -> UIView? {
		if let cachedIndicatorView { return cachedIndicatorView }

		if let found = descendants(of: self)
			.first(where: { String(describing: type(of: $0)) == "_UILiquidLensView" }) {
			cachedIndicatorView = found
			return found
		}

		let segs = segments()
		guard let container = segs.first?.superview,
					let wrapper = container.superview else { return nil }

		let fallback = wrapper.subviews.first {
			$0 !== container && !$0.subviews.isEmpty
		}

		cachedIndicatorView = fallback
		return fallback
	}

	private func indicatorRect() -> CGRect {
		if let view = indicatorView() {
			let layer = view.layer.presentation() ?? view.layer
			let selfLayer = self.layer.presentation() ?? self.layer
			return selfLayer.convert(layer.bounds, from: layer)
		}

		if !didLogFallback {
			fabBarLogger.warning(
				"Glass indicator not found; accent mask snapping."
			)
			didLogFallback = true
		}

		let segs = segments()

		guard selectedSegmentIndex >= 0,
					selectedSegmentIndex < segs.count else { return .zero }

		return segs[selectedSegmentIndex].frame
	}

	fileprivate func updateAccentMasks() {
		let rect = indicatorRect()

		if rect == lastIndicatorRect {
			stableFrameCount += 1
			if stableFrameCount >= Self.stableFrames {
				displayLink?.isPaused = true
				return
			}
		} else {
			stableFrameCount = 0
			lastIndicatorRect = rect
		}

		CATransaction.begin()
		CATransaction.setDisableActions(true)

		for (base, accent) in zip(contentViews, accentViews) {
			updateMask(base: base, accent: accent, rect: rect)
		}

		CATransaction.commit()
	}

	private func updateMask(
		base: TabItemContentView,
		accent: TabItemContentView,
		rect: CGRect
	) {
		let layer = accent.layer.presentation() ?? accent.layer
		let selfLayer = self.layer.presentation() ?? self.layer
		let frame = selfLayer.convert(layer.bounds, from: layer)

		let local = CGRect(
			x: rect.minX - frame.minX,
			y: rect.minY - frame.minY,
			width: rect.width,
			height: rect.height
		)

		let path = UIBezierPath(
			roundedRect: local,
			cornerRadius: rect.height / 2
		)

		shapeMask(for: accent).path = path.cgPath

		guard rect.intersects(frame) else {
			base.layer.mask = nil
			return
		}

		let basePath = UIBezierPath(rect: base.bounds)
		basePath.append(path)

		let mask = shapeMask(for: base)
		mask.fillRule = .evenOdd
		mask.path = basePath.cgPath
	}

	private func shapeMask(for view: UIView) -> CAShapeLayer {
		if let mask = view.layer.mask as? CAShapeLayer { return mask }
		let mask = CAShapeLayer()
		view.layer.mask = mask
		return mask
	}

	private func index(at point: CGPoint) -> Int {
		guard numberOfSegments > 0 else { return 0 }
		let width = bounds.width / CGFloat(numberOfSegments)
		return min(max(Int(point.x / width), 0), numberOfSegments - 1)
	}

	private var instantTracking: Bool {
		!traitCollection.preferredContentSizeCategory
			.isAccessibilityCategory
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return super.touchesBegan(touches, with: event)
		}

		wakeDisplayLink()

		if instantTracking {
			originalIndex = selectedSegmentIndex
			selectedSegmentIndex = index(at: touch.location(in: self))
		}

		super.touchesBegan(touches, with: event)
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return super.touchesMoved(touches, with: event)
		}

		wakeDisplayLink()

		let newIndex = index(at: touch.location(in: self))

		if instantTracking, selectedSegmentIndex != newIndex {
			selectedSegmentIndex = newIndex
		}

		super.touchesMoved(touches, with: event)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		wakeDisplayLink()

		if instantTracking, let originalIndex {
			selectedSegmentIndex != originalIndex
			? sendActions(for: .valueChanged)
			: onReselect?(selectedSegmentIndex)
		}

		self.originalIndex = nil
		super.touchesEnded(touches, with: event)
	}

	override func touchesCancelled(
		_ touches: Set<UITouch>,
		with event: UIEvent?
	) {
		wakeDisplayLink()

		if instantTracking, let originalIndex {
			selectedSegmentIndex = originalIndex
		}

		self.originalIndex = nil
		super.touchesCancelled(touches, with: event)
	}
}

@available(iOS 26.0, *)
@MainActor
private final class TabBarDisplayLinkProxy: NSObject {

	weak var control: TabBarSegmentedControl?

	init(control: TabBarSegmentedControl) {
		self.control = control
	}

	@objc func tick(_ link: CADisplayLink) {
		guard let control else {
			link.invalidate()
			return
		}

		control.updateAccentMasks()
	}
}
