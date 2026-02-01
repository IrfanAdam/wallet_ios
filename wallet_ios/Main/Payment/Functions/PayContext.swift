import SwiftUI

// MARK: - Payment Context
@Observable
final class InitiatePaymentContext {
	// Amount
	var integerPart: String = ""
	var decimalPart: String = ""
	var selectedCurrency: String = "INR"
	
	// UI flow
	var showTags: Bool = false
	var hasContinued: Bool = false
	var isAuthenticating: Bool = false
	
	// Tags & note
	var note: String = ""
	var selectedTags: [PaymentTag] = [.remittance]
	
	// Toolbar
	//	var toolbarHeight: CGFloat = 0
	
	// Derived
	var fullAmount: String {
		decimalPart.isEmpty ? integerPart : "\(integerPart).\(decimalPart)"
	}
}
