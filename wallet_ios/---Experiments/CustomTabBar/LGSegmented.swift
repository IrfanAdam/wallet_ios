import SwiftUI
import UIKit

// MARK: - UISegmentedControl Wrapper (the glass "engine")

struct GlassSegmentedControl: UIViewRepresentable {
	let count: Int
	var size: CGSize
	@Binding var selectedIndex: Int
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
		return size
	}
	
	func makeUIView(context: Context) -> UISegmentedControl {
		// Build with empty-string segments — we overlay custom SwiftUI views on top
		let items = Array(repeating: "" as Any, count: count)
		let control = UISegmentedControl(items: items)
		control.selectedSegmentIndex = selectedIndex
		
		// Make the control itself invisible — only the glass bubble remains
		control.backgroundColor = .clear
		control.selectedSegmentTintColor = .clear

		// Remove all text/divider attributes
		let transparent: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.clear,
			.font: UIFont.systemFont(ofSize: 0)
		]
		control.setTitleTextAttributes(transparent, for: .normal)
		control.setTitleTextAttributes(transparent, for: .selected)
		control.setDividerImage(
			UIImage(),
			forLeftSegmentState: .normal,
			rightSegmentState: .normal,
			barMetrics: .default
		)
		
		DispatchQueue.main.async {
			for subview in control.subviews {
				if subview is UIImageView && subview != control.subviews.last {
					subview.alpha = 0
				}
			}
		}
		
		control.addTarget(
			context.coordinator,
			action: #selector(Coordinator.valueChanged(_:)),
			for: .valueChanged
		)
		return control
	}
	
	func updateUIView(_ uiView: UISegmentedControl, context: Context) {
		if uiView.selectedSegmentIndex != selectedIndex {
			uiView.selectedSegmentIndex = selectedIndex
		}
	}
	
	class Coordinator: NSObject {
		var parent: GlassSegmentedControl
		init(_ parent: GlassSegmentedControl) { self.parent = parent }
		
		@objc func valueChanged(_ sender: UISegmentedControl) {
			parent.selectedIndex = sender.selectedSegmentIndex
		}
	}
}
