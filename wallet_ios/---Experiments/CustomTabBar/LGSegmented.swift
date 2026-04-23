import SwiftUI
import UIKit

// MARK: - UISegmentedControl Wrapper (the glass "engine")

struct GlassSegmentedControl<TabItemView: View>: UIViewRepresentable {
	var size: CGSize
	var activeTint: Color = .blue
	var barTint: Color = .white.opacity(0.4)
	@Binding var activeTab: CustomTab
	@ViewBuilder var tabItemView: (CustomTab) -> TabItemView

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> UISegmentedControl {
		let items = CustomTab.allCases.map(\.rawValue)
		let control = UISegmentedControl(items: items)
		control.selectedSegmentIndex = 0

		for (index, tab) in CustomTab.allCases.enumerated() {
			let renderer = ImageRenderer(content: tabItemView(tab))
			renderer.scale = 2

			let image = renderer.uiImage

			control.setImage(image, forSegmentAt: index)
		}

		DispatchQueue.main.async {
			for subview in control.subviews {
				if subview is UIImageView && subview != control.subviews.last {
					subview.alpha = 0
				}
			}
		}

		control.selectedSegmentTintColor = UIColor(Color.gray.opacity(0.2))
		control.setTitleTextAttributes([
			.foregroundColor: UIColor(activeTint)
		], for: .selected)


		control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
		return control
	}


	func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
		return size
	}

	func updateUIView(_ uiView: UISegmentedControl, context: Context) {

		uiView.selectedSegmentIndex = activeTab.index

		for (index, tab) in CustomTab.allCases.enumerated() {
			let renderer = ImageRenderer(content: tabItemView(tab))
			renderer.scale = 2

			if let image = renderer.uiImage {
				uiView.setImage(image, forSegmentAt: index)
			}
		}

	}
	
	class Coordinator: NSObject {
		var parent: GlassSegmentedControl
		init(_ parent: GlassSegmentedControl) { self.parent = parent }
		
		@objc func tabSelected(_ control: UISegmentedControl) {
			parent.activeTab = CustomTab.allCases[control.selectedSegmentIndex]
		}
	}
}

