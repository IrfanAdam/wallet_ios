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
	@State private var showLiquidGlassTest = false
	let sheetController: AppSheetController
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

				Button("Open Global Sheet") {
					sheetController.present()
				}


				NavigationLink {
					// Add your destination view here
					RewardGames()
				} label: {
					Text("View My Rewards")
						.font(.headline)
						.foregroundStyle(.white)
						.padding()
						.background(Color.blue)
						.cornerRadius(12)
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
					Button("Test") {
						showLiquidGlassTest = true
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
						.padding(.horizontal, 4)
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
			.fullScreenCover(isPresented: $showLiquidGlassTest) {
				DemoTabView()
			}
		}
	}
}

#Preview {
	HomeView(sheetController: AppSheetController())
}

