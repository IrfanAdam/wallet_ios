import SwiftUI

@MainActor
@Observable
final class AppSheetController {
	
	private(set) var isPresented = false
	private(set) var sheetHeight: CGFloat = 0
	private var _screenHeight: CGFloat = 0
	
	var screenHeight: CGFloat { _screenHeight }
	
	
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
		withAnimation(.snappy(duration: 0.25, extraBounce: 0.1)) {
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
			set: { if !$0 { self.dismiss() } }
		)
	}
}
