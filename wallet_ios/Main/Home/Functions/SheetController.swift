import SwiftUI

@MainActor
@Observable
final class AppSheetController {
	private(set) var isPresented = false
	private(set) var sheetHeight: CGFloat = 0
	private var _screenHeight: CGFloat = 0

	var screenHeight: CGFloat {
		_screenHeight
	}

	func updateScreenHeight(_ height: CGFloat) {
		_screenHeight = height
	}

	func primeInitialHeight() {
		guard sheetHeight == 0, screenHeight > 0 else { return }
		// Match UIKit's medium detent
		sheetHeight = screenHeight * 0.5
	}

	func present() {
		sheetHeight = 0
		isPresented = true
	}

	func dismiss() {
		isPresented = false
	}

	func setHeight(_ height: CGFloat) {
		withAnimation(
			.interpolatingSpring(
				stiffness: 300,
				damping: 45
			)
		) {
			sheetHeight = height
		}
	}

	func snapToMedium() {
		guard screenHeight > 0 else { return }
		setHeight(screenHeight * 0.5)
	}

	func snapToLarge() {
		guard screenHeight > 0 else { return }
		setHeight(screenHeight * 0.9)
	}

	var isPresentedBinding: Binding<Bool> {
		Binding(
			get: { self.isPresented },
			set: {
				if !$0 {
					self.dismiss()
				}
			}
		)
	}
}

struct WindowReader: UIViewRepresentable {
	var onResolve: (UIScreen) -> Void

	init(_ onResolve: @escaping (UIScreen) -> Void) {
		self.onResolve = onResolve
	}

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		DispatchQueue.main.async {
			if let screen = view.window?.windowScene?.screen {
				onResolve(screen)
			}
		}
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Animatable Height Modifier
struct SetSheetHeight: ViewModifier, Animatable {
	var height: CGFloat
	var screenHeight: CGFloat

	var animatableData: CGFloat {
		get { height }
		set { height = newValue }
	}

	func body(content: Content) -> some View {
		let threshold = screenHeight * 0.9

		// Compute detent safely
		let detent: PresentationDetent = {
			if height == 0 {
				return .medium
			} else if height >= threshold {
				return .large
			} else {
				return .height(height)
			}
		}()

		return content.presentationDetents([detent])
	}
}
