import SwiftUI

// MARK: - Imperative Sheet Controller (No Observation)
@MainActor
@Observable
final class AppSheetController {

	private(set) var isPresented: Bool = false
	private(set) var availableDetents: [PresentationDetent] = [.medium, .large]
	private(set) var selectedDetent: PresentationDetent = .medium

	private var onChange: (() -> Void)?

	func bind(onChange: @escaping () -> Void) {
		self.onChange = onChange
	}

	func present() {
		guard !isPresented else { return }
		isPresented = true
		onChange?()
	}

	func dismiss() {
		guard isPresented else { return }
		isPresented = false
		onChange?()
	}

	func setDetent(_ detent: PresentationDetent) {
		DispatchQueue.main.async {
			if !self.availableDetents.contains(detent) {
				self.availableDetents.append(detent)
			}
			self.selectedDetent = detent
			self.onChange?()
		}
	}


	var isPresentedBinding: Binding<Bool> {
		Binding(
			get: { self.isPresented },
			set: { presented in
				if !presented {
					self.dismiss()
				}
			}
		)
	}

	var detentSelectionBinding: Binding<PresentationDetent> {
		Binding(
			get: { self.selectedDetent },
			set: { newValue in
				self.setDetent(newValue)
			}
		)
	}
}
