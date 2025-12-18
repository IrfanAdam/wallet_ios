import SwiftUI


private struct SheetDismissKey: EnvironmentKey {
	static let defaultValue: () -> Void = {}
}

struct SheetControl {
	let dismiss: () -> Void
	let setDetent: (PresentationDetent) -> Void
}

private struct SheetControlKey: EnvironmentKey {
	static let defaultValue = SheetControl(
		dismiss: {},
		setDetent: { _ in }
	)
}

extension EnvironmentValues {
	var dismissCurrentSheet: () -> Void {
		get { self[SheetDismissKey.self] }
		set { self[SheetDismissKey.self] = newValue }
	}
	
	var sheetControl: SheetControl {
		get { self[SheetControlKey.self] }
		set { self[SheetControlKey.self] = newValue }
	}
}


struct HomeView: View {
	@State private var showDetails = false
	@State private var showScan = false
	var body: some View {
		// First tab
		NavigationStack {
			VStack {
				DataWidget()
					.frame(maxWidth: 200)
					.onTapGesture {
						showDetails = true
					}
					.sheet(isPresented: $showDetails) {
						AnalyticsSheet()
					}

				VStack(alignment: .leading, spacing: 12) {
					Text("Horizontal Scroll")
						.font(.headline)
						.padding(.horizontal, 20)

					PaymentActionsGrid()
				}
			}
			.navigationTitle("Home")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {
						print("Menu tapped")
					}) {
						Image(systemName: "line.horizontal.3")
							.font(.title2)
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						print("Notifications tapped")
					}) {
						Image(systemName: "bell.fill")
							.font(.title2)
					}
				}
			}
			.safeAreaInset(edge: .bottom, alignment: .trailing) {
				Button {
					showScan = true
				} label: {
					Image(systemName: "qrcode.viewfinder")
						.font(.title.weight(.semibold))
						.padding(.horizontal, 8)
						.padding(.vertical, 8)
				}
				.buttonStyle(.glassProminent)
				.padding(.horizontal, 24)
				.padding(.vertical, 16)
				.tint(.blue.opacity(0.9))
			}
			.fullScreenCover(isPresented: $showScan) {
				transactOpts().ignoresSafeArea()
			}
		}
	}
}

struct PaymentActionsGrid: View {
	@Namespace private var morphNS
	@State private var detent: PresentationDetent = .large
	@State private var showPageSheet = false
	let actions: [PaymentAction] = [
		PaymentAction(title: "Pay", icon: "arrow.up") { print("Pay tapped") },
		PaymentAction(title: "International", icon: "globe") { print("Pay tapped") },
		PaymentAction(title: "Request", icon: "arrow.down.to.line") { print("Request tapped") },
		PaymentAction(title: "Withdraw", icon: "arrow.down.left.hand.draw") { print("Withdraw tapped") },
		PaymentAction(title: "Deposit", icon: "arrow.up.right.hand.draw") { print("Deposit tapped") },
		PaymentAction(title: "Split", icon: "arrow.triangle.branch") { print("Split tapped") }
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
		}.environment(\.sheetControl, SheetControl(
			dismiss: { showPageSheet = false },
			setDetent: { detent = $0 }
		))
	}
}

#Preview {
	HomeView()
}

