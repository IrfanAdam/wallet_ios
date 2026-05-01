import SwiftUI
import UIKit

@available(iOS 26.0, *)
struct FabBarRepresentable<Value: Hashable>: UIViewRepresentable {

	var tabs: [FabBarTab<Value>]
	var action: FabBarAction
	@Binding var activeTab: Value

	func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

	func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize {
		uiView.layoutIfNeeded()
		return uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}

	func makeUIView(context: Context) -> GlassTabBarView {
		let images = tabs.map { _ in UIImage(systemName: "circle") }
		let control = TabBarSegmentedControl(items: images)

		control.showsLargeContentViewer = false
		control.selectedSegmentIndex = selectedTabIndex()
		control.selectedSegmentTintColor = segmentTintColor(for: control.traitCollection)

		configureSegmentContent(on: control, context: context)

		control.addTarget(
			context.coordinator,
			action: #selector(context.coordinator.tabSelected(_:)),
			for: .valueChanged
		)

		control.layer.shadowColor = UIColor.baseBlue.cgColor
		control.layer.shadowOpacity = 0.42
		control.layer.shadowRadius = 0
		control.layer.shadowOffset = .zero

		let coordinator = context.coordinator

		control.onReselect = { [weak coordinator] index in
			guard let coordinator, index >= 0, index < coordinator.parent.tabs.count else { return }
			coordinator.parent.tabs[index].onReselect?()
		}

		return GlassTabBarView(segmentedControl: control, tabCount: tabs.count, action: action)
	}

	func updateUIView(_ uiView: GlassTabBarView, context: Context) {
		context.coordinator.parent = self

		let control = uiView.segmentedControl
		control.selectedSegmentTintColor = segmentTintColor(for: uiView.traitCollection)

		syncTabsIfNeeded(control: control, uiView: uiView, context: context)

		if control.selectedSegmentIndex != selectedTabIndex() { control.selectedSegmentIndex = selectedTabIndex() }

		if uiView.tintAdjustmentMode == .normal, let tint = uiView.tintColor {
			control.activeTintColor = UIColor(cgColor: tint.cgColor)
		}
	}

	private func syncTabsIfNeeded(control: TabBarSegmentedControl, uiView: GlassTabBarView, context: Context) {
		let currentTabValues = tabs.map(\.value)
		guard currentTabValues != context.coordinator.previousTabValues else { return }

		context.coordinator.previousTabValues = currentTabValues
		control.removeAllSegments()

		for _ in tabs {
			control.insertSegment(with: UIImage(systemName: "circle"), at: control.numberOfSegments, animated: false)
		}

		configureSegmentContent(on: control, context: context)
		uiView.updateTabCount(tabs.count)
	}

	private func selectedTabIndex() -> Int { tabs.firstIndex { $0.value == activeTab } ?? 0 }

	private func configureSegmentContent(on control: TabBarSegmentedControl, context: Context) {
		for (index, tab) in tabs.enumerated() { control.setTitle(tab.title, forSegmentAt: index) }

		let baseViews = tabs.map { makeContentView(for: $0) }
		let accentViews = tabs.map { makeContentView(for: $0, filled: true) }

		context.coordinator.baseViews = baseViews
		context.coordinator.accentViews = accentViews

		(baseViews + accentViews).forEach {
			$0.layer.shouldRasterize = true
			$0.layer.rasterizationScale = $0.window?.windowScene?.screen.scale ?? $0.traitCollection.displayScale
		}

		control.configureContentViews(baseViews, accentViews: accentViews)

		let width = tabs.count < 3 ? Constants.fewTabsSegmentWidth : 0
		for index in 0..<tabs.count { control.setWidth(width, forSegmentAt: index) }
	}

	private func makeContentView(for tab: FabBarTab<Value>, filled: Bool = false) -> TabItemContentView {
		switch tab.icon {

		case .system(let name):
			return TabItemContentView(title: tab.title, symbolName: filled ? name + ".fill" : name)

		case .asset(let name, let bundle, let rendering):
			let mode: UIImage.RenderingMode = rendering == .template ? .alwaysTemplate : .alwaysOriginal
			let finalName = mode == .alwaysOriginal ? name : (filled ? name + "-duotone" : name)
			let showRing = filled && mode == .alwaysOriginal

			return TabItemContentView(
				title: tab.title,
				imageName: finalName,
				imageBundle: bundle,
				renderingMode: mode,
				showRing: showRing
			)
		}
	}

	private func segmentTintColor(for traitCollection: UITraitCollection) -> UIColor {
		switch traitCollection.userInterfaceStyle {
		case .dark: return .baseBlue.withAlphaComponent(0.15)
		default: return .baseBlue.withAlphaComponent(0.08)
		}
	}

	@MainActor
	class Coordinator: NSObject {

		var parent: FabBarRepresentable<Value>
		var previousTabValues: [Value]

		var baseViews: [TabItemContentView] = []
		var accentViews: [TabItemContentView] = []

		init(parent: FabBarRepresentable<Value>) {
			self.parent = parent
			self.previousTabValues = parent.tabs.map(\.value)
		}

		@objc
		func tabSelected(_ control: UISegmentedControl) {
			let index = control.selectedSegmentIndex
			guard index >= 0, index < parent.tabs.count else { return }

			parent.activeTab = parent.tabs[index].value

			UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut]) {
				control.alpha = 0.98
			} completion: { _ in
				UIView.animate(withDuration: 0.1) { control.alpha = 1 }
			}
		}
	}
}

extension UIColor {
	static let baseBlue = UIColor(red: 0, green: 0.55, blue: 1, alpha: 1)
}
