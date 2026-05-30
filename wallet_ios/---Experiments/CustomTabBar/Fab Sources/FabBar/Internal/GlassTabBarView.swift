import UIKit

/// The root UIKit view that assembles the tab bar with glass effects.
/// Uses UIGlassContainerEffect to enable morphing between the segmented control and FAB.
@available(iOS 26.0, *)
final class GlassTabBarView: UIView {

	let containerEffectView: UIVisualEffectView
	let segmentedGlassView: UIVisualEffectView
	let segmentedControl: TabBarSegmentedControl
	let fabGlassView: UIVisualEffectView
	let fabButton: UIButton

	private let spacing: CGFloat = Constants.fabSpacing
	private let contentPadding: CGFloat = Constants.contentPadding

	private(set) var tabCount: Int
	private var segmentedTrailingConstraint: NSLayoutConstraint?

	init(segmentedControl: TabBarSegmentedControl, tabCount: Int, action: FabBarAction) {
		self.segmentedControl = segmentedControl
		self.tabCount = tabCount

		let containerEffect = UIGlassContainerEffect()
		containerEffect.spacing = Constants.fabSpacing
		containerEffectView = UIVisualEffectView(effect: containerEffect)

		let segmentedGlassEffect = UIGlassEffect(style: .clear)
		segmentedGlassEffect.isInteractive = true
		segmentedGlassView = UIVisualEffectView(effect: segmentedGlassEffect)

		let fabGlassEffect = UIGlassEffect(style: .clear)
		fabGlassEffect.isInteractive = true
		fabGlassEffect.tintColor = .tintColor.withAlphaComponent(0.9)
		fabGlassView = UIVisualEffectView(effect: fabGlassEffect)

		let button = UIButton(type: .system)

		let image: UIImage?
		if let custom = action.image {
			image = UIImage(named: custom, in: action.imageBundle, with: nil)
		} else if let system = action.systemImage {
			let config = UIImage.SymbolConfiguration(pointSize: Constants.fabIconPointSize, weight: .medium)
			image = UIImage(systemName: system, withConfiguration: config)
		} else {
			image = nil
		}

		button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
		button.tintColor = .white
		button.accessibilityLabel = action.accessibilityLabel
		button.accessibilityTraits = .button
		fabButton = button

		super.init(frame: .zero)
		// Apply shadow to the entire tab bar view for depth

		tintAdjustmentMode = .automatic
		fabGlassView.tintAdjustmentMode = .automatic
		fabButton.tintAdjustmentMode = .automatic

		setupViews(action: action)
		applyShadow()
	}

	private func setupViews(action: FabBarAction) {
		addSubview(containerEffectView)
		containerEffectView.translatesAutoresizingMaskIntoConstraints = false

		containerEffectView.contentView.addSubview(segmentedGlassView)
		segmentedGlassView.translatesAutoresizingMaskIntoConstraints = false

		segmentedGlassView.contentView.addSubview(segmentedControl)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false

		containerEffectView.contentView.addSubview(fabGlassView)
		fabGlassView.translatesAutoresizingMaskIntoConstraints = false

		fabGlassView.contentView.addSubview(fabButton)
		fabButton.translatesAutoresizingMaskIntoConstraints = false

		fabButton.addAction(UIAction { _ in action.action() }, for: .touchUpInside)

		let segmentedControlBottomInsetAdjustment: CGFloat = 1

		NSLayoutConstraint.activate([
			containerEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
			containerEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
			containerEffectView.topAnchor.constraint(equalTo: topAnchor),
			containerEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

			segmentedGlassView.leadingAnchor.constraint(equalTo: containerEffectView.contentView.leadingAnchor),
			segmentedGlassView.topAnchor.constraint(equalTo: containerEffectView.contentView.topAnchor),
			segmentedGlassView.bottomAnchor.constraint(equalTo: containerEffectView.contentView.bottomAnchor),

			segmentedControl.leadingAnchor.constraint(equalTo: segmentedGlassView.contentView.leadingAnchor, constant: contentPadding),
			segmentedControl.trailingAnchor.constraint(equalTo: segmentedGlassView.contentView.trailingAnchor, constant: -contentPadding),
			segmentedControl.topAnchor.constraint(equalTo: segmentedGlassView.contentView.topAnchor, constant: contentPadding),
			segmentedControl.bottomAnchor.constraint(equalTo: segmentedGlassView.contentView.bottomAnchor, constant: -contentPadding - segmentedControlBottomInsetAdjustment),

			fabGlassView.trailingAnchor.constraint(equalTo: containerEffectView.contentView.trailingAnchor),
			fabGlassView.topAnchor.constraint(equalTo: containerEffectView.contentView.topAnchor),
			fabGlassView.bottomAnchor.constraint(equalTo: containerEffectView.contentView.bottomAnchor),
			fabGlassView.widthAnchor.constraint(equalTo: fabGlassView.heightAnchor),

			fabButton.leadingAnchor.constraint(equalTo: fabGlassView.contentView.leadingAnchor),
			fabButton.trailingAnchor.constraint(equalTo: fabGlassView.contentView.trailingAnchor),
			fabButton.topAnchor.constraint(equalTo: fabGlassView.contentView.topAnchor),
			fabButton.bottomAnchor.constraint(equalTo: fabGlassView.contentView.bottomAnchor)
		])

		segmentedTrailingConstraint = makeSegmentedTrailingConstraint()
		segmentedTrailingConstraint?.isActive = true

		segmentedControl.setContentHuggingPriority(.required, for: .vertical)
		segmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)
	}

	/// Creates the appropriate trailing constraint for the segmented glass view.
	/// For 3+ tabs, fills to the FAB. For fewer tabs, floats leading-aligned.
	private func makeSegmentedTrailingConstraint() -> NSLayoutConstraint {
		tabCount >= 3
		? segmentedGlassView.trailingAnchor.constraint(equalTo: fabGlassView.leadingAnchor, constant: -spacing)
		: segmentedGlassView.trailingAnchor.constraint(lessThanOrEqualTo: fabGlassView.leadingAnchor, constant: -spacing)
	}

	/// Updates the tab count and swaps the trailing constraint to match.
	func updateTabCount(_ newCount: Int) {
		guard newCount != tabCount else { return }

		tabCount = newCount
		segmentedTrailingConstraint?.isActive = false
		segmentedTrailingConstraint = makeSegmentedTrailingConstraint()
		segmentedTrailingConstraint?.isActive = true
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: - Shadow Configuration
	private func applyShadow() {
		// Use a subtle black shadow with medium blur and a slight vertical offset.
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.09
		layer.shadowRadius = 10
		layer.shadowOffset = CGSize(width: 0, height: 6)
		layer.masksToBounds = false
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		segmentedGlassView.cornerConfiguration = .capsule()
		fabGlassView.cornerConfiguration = .capsule()
		// Optimize shadow rendering by setting a shadowPath matching the view's bounds.
//		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 36).cgPath
		segmentedGlassView.layer.shadowPath = UIBezierPath(
			roundedRect: segmentedGlassView.bounds,
			cornerRadius: segmentedGlassView.bounds.height / 2
		).cgPath
	}

	override func tintColorDidChange() {
		super.tintColorDidChange()

		let newEffect = UIGlassEffect(style: .clear)
		newEffect.isInteractive = true
		newEffect.tintColor = tintColor.withAlphaComponent(0.9)

		fabGlassView.effect = newEffect
	}
}
