import Foundation

@available(iOS 26.0, *)
public enum FabBarIcon {
	case system(name: String)
	case asset(name: String, bundle: Bundle? = nil, rendering: Rendering = .template)
	
	public enum Rendering {
		case template
		case original
	}
}

@available(iOS 26.0, *)
public struct FabBarTab<Value: Hashable>: Identifiable {
	public var id: Value { value }
	
	/// The tab identifier.
	public let value: Value
	
	/// The title displayed below the icon.
	public let title: String
	
	/// Unified icon representation
	public let icon: FabBarIcon
	
	/// Called when the user taps this tab while it's already selected.
	public let onReselect: (() -> Void)?
	
	// MARK: - Initializers
	
	/// SF Symbol initializer
	public init(
		value: Value,
		title: String,
		systemImage: String,
		onReselect: (() -> Void)? = nil
	) {
		self.value = value
		self.title = title
		self.icon = .system(name: systemImage)
		self.onReselect = onReselect
	}
	
	/// Custom asset initializer
	public init(
		value: Value,
		title: String,
		customIcon name: String,
		bundle: Bundle? = nil,
		rendering: FabBarIcon.Rendering = .template,
		onReselect: (() -> Void)? = nil
	) {
		self.value = value
		self.title = title
		self.icon = .asset(name: name, bundle: bundle ?? .main, rendering: rendering)
		self.onReselect = onReselect
	}
}
