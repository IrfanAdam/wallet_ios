import SwiftUI

struct PaymentActionsGrid: View {
	@Namespace private var morphNS
	@State private var detent: PresentationDetent = .large
	@State private var showPageSheet = false
	
	let actions: [PaymentAction] = [
		PaymentAction(title: "Pay", icon: "arrow.up"),
		PaymentAction(title: "International", icon: "globe"),
		PaymentAction(title: "Request", icon: "arrow.down.to.line"),
		PaymentAction(title: "Withdraw", icon: "arrow.down.left.hand.draw"),
		PaymentAction(title: "Deposit", icon: "arrow.up.right.hand.draw"),
		PaymentAction(title: "Split", icon: "arrow.triangle.branch")
	]
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 12) {
				ForEach(actions) { action in
					
					PaymentActionCard(
						title: action.title,
						icon: action.icon,
					  action: {
							showPageSheet = true
						}
					)
					.frame(width: 140)
				}
			}
			.padding(.horizontal, 20)
		}
		.sheet(isPresented: $showPageSheet) {
			SearchPage(detent: $detent, namespace: morphNS)
				.presentationDetents([.medium, .large], selection: $detent)
				.presentationDragIndicator(.visible)
				.presentationBackground(
					Color(red: 250/255, green: 248/255, blue: 245/255)
				)
		}
		.environment(
			\.sheetControl,
			 SheetControl(
				dismiss: { showPageSheet = false },
				setDetent: { detent = $0 }
			 )
		)
	}
}
