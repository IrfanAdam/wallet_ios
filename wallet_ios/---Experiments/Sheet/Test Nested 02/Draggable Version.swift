import SwiftUI

struct SheetDrag: View {
	@State private var sheetDetent: PresentationDetent = .medium
	
	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				Text("Main view behind sheet")
					.font(.title)
			}
			.navigationTitle("Host Toolbar Visible")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {}) {
						Label("Host Action", systemImage: "star")
					}
				}
			}
			.sheet(isPresented: .constant(true)) {
				SheetContent(currentDetent: $sheetDetent)
					.presentationDetents([.medium, .large], selection: $sheetDetent)
					.presentationBackgroundInteraction(.enabled(upThrough: .large))
					.presentationDragIndicator(.visible)
					.interactiveDismissDisabled(true)
					.presentationBackground(.white)
			}
		}
	}
}

struct SheetContent: View {
	@Binding var currentDetent: PresentationDetent
	
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
						.offset(y: isLarge ? 0 : -44)
					}
				}
			}
			.navigationTitle(isLarge ? "Large Sheet" : "")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if isLarge {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Close") {}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Edit") {}
					}
				}
			}
			.toolbar(isLarge ? .visible : .hidden, for: .navigationBar)
			.animation(.easeInOut(duration: 0.3), value: isLarge)
		}
		.background(DimmingViewModifier(isLarge: isLarge))
	}
}

// Custom view modifier to control dimming
struct DimmingViewModifier: UIViewRepresentable {
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

struct SheetDrag_Previews: PreviewProvider {
	static var previews: some View {
		SheetDrag()
	}
}
