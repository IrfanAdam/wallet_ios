import SwiftUI

// MARK: - Environment Key

@available(iOS 26.0, *)
extension EnvironmentValues {
    /// The bottom safe area padding needed to clear the FabBar.
    /// This is `barHeight + bottomPadding` minus the device's bottom safe area inset.
    @Entry var fabBarBottomSafeAreaPadding: CGFloat = Constants.barHeight + Constants.bottomPadding
}

// MARK: - View Modifier

/// View modifier that applies bottom safe area padding to clear the FabBar.
@available(iOS 26.0, *)
struct FabBarSafeAreaPaddingModifier: ViewModifier {
    @Environment(\.fabBarBottomSafeAreaPadding) private var padding

    func body(content: Content) -> some View {
        content.safeAreaPadding(.bottom, padding)
    }
}

@available(iOS 26.0, *)
public extension View {
    /// Applies bottom safe area padding to clear the FabBar.
    ///
    /// Use this on scrollable content within each tab to ensure
    /// content isn't hidden behind the FabBar.
    ///
    /// ```swift
    /// Tab(value: .home) {
    ///     HomeView()
    ///         .fabBarSafeAreaPadding()
    ///         .toolbarVisibility(.hidden, for: .tabBar)
    /// }
    /// ```
    func fabBarSafeAreaPadding() -> some View {
        modifier(FabBarSafeAreaPaddingModifier())
    }
}
