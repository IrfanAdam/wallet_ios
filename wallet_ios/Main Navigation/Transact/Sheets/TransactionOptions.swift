import SwiftUI

struct TransactOptions: View {
	@Binding var currentDetent: PresentationDetent
	@State private var searchText = ""

	private var isLarge: Bool {
		currentDetent == .large
	}

	var body: some View {
		NavigationStack {
			ZStack {
				GeometryReader { geometry in
					ScrollView {
						VStack(spacing: 16) {
							Text("Sheet body — size: \(isLarge ? "Large" : "Medium")")
								.font(.headline)

							Text("Drag me up and down!")
								.foregroundColor(.secondary)

							// Add more content to demonstrate scrolling
							ForEach(0..<20) { i in
								RoundedRectangle(cornerRadius: 8)
									.fill(Color.blue.opacity(0.1))
									.frame(height: 60)
									.overlay(
										Text("Item \(i + 1)")
									)
							}

							Spacer(minLength: 50)
						}
						.padding()
					}
				}
			}
			.navigationTitle(isLarge ? "Large Sheet" : "")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
//				if isLarge {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							// Snap back to medium detent
							currentDetent = .medium
						} label: {
							Label("Minimize", systemImage: "chevron.down")
						}
						.opacity(isLarge ? 1 : 0)
						.disabled(!isLarge)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Scan") {}.buttonStyle(.glassProminent)
							.opacity(isLarge ? 1 : 0)
							.disabled(!isLarge)
					}
//				}
			}
			.toolbar(isLarge ? .visible : .hidden, for: .navigationBar)
			.animation(.easeInOut(duration: 0.3), value: isLarge)
		}
		.searchable(
			text: $searchText,
			placement: .navigationBarDrawer(displayMode: .always)
		)
		.background(RevealToolbar(isLarge: isLarge))
	}
}

// Custom view modifier to control dimming
struct RevealToolbar: UIViewRepresentable {
	let isLarge: Bool

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		DispatchQueue.main.async {
			if let windowScene = uiView.window?.windowScene,
				 let window = windowScene.windows.first,
				 let sheet = window.rootViewController?.presentedViewController?.presentationController as? UISheetPresentationController {

				// When large, show dimming (undimmed only up to medium)
				// When medium, no dimming (undimmed up to large)
				sheet.largestUndimmedDetentIdentifier = isLarge ? .medium : .large
			}
		}
	}
}
