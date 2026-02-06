import SwiftUI

#Preview {
	FlowRenderer(items: [
		.text("Jabari M. yyyy iyiy uihiuh", .primary),
		.text("will send", .secondary),
		.text("CFA 1500", .primary),
		.pill("Daily"),
		.text("for Groceries", .secondary),
		.pill("Category"),
		.text("for Groceries", .secondary)
	])
	.padding(0)
}
