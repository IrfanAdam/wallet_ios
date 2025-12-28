import SwiftUI

// MARK: - Root Host

struct DragResizableSheetLauncherView: View {
	
	private let sheetController = AppSheetController()
	@State private var screenHeight: CGFloat = 0
	
	var body: some View {
		VStack(spacing: 24) {
			Text("App Root")
				.font(.largeTitle)
			
			Button("Present Sheet") {
				sheetController.present()
			}
		}
		.background(
			WindowReader { screen in
				screenHeight = screen.bounds.height
				sheetController.updateScreenHeight(screen.bounds.height)
			}
		)
		.sheet(isPresented: sheetController.isPresentedBinding) {
			DragResizableSheetRootView(
				controller: sheetController
			)
			.background(
				GeometryReader { proxy in
					Color.clear
						.gesture(
							DragGesture()
								.onChanged { value in
									let minHeight: CGFloat = 200
									let maxHeight: CGFloat = sheetController.screenHeight * 0.9
									// Subtract vertical drag to match UIKit behavior
									let newHeight = max(minHeight, min(maxHeight, sheetController.sheetHeight - value.translation.height))
									sheetController.setHeight(newHeight)
								}
								.onEnded { value in
									// Optional snapping
									let mid = sheetController.screenHeight * 0.7
									if sheetController.sheetHeight < mid {
										sheetController.snapToMedium()
									} else {
										sheetController.snapToLarge()
									}
								}
						)
				}
			)
			.presentationDragIndicator(.visible) // optional visual grabber
		}
	}
}

// MARK: - Sheet Root (Level 1)

struct DragResizableSheetRootView: View {
	
	@State private var windowHeight: CGFloat = 0
	let controller: AppSheetController
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				
				NavigationLink("Go to Level Two") {
					DragResizableSheetDetailView(
						setHeight: controller.setHeight,
						setMedium: {
							controller.snapToMedium()
						},
						setLarge: {
							controller.snapToLarge()
						},
						dismiss: controller.dismiss
					)
				}
				
				Button("Snap to Medium") {
					controller.snapToMedium()
				}
				
				Button("Expand to Large") {
					controller.snapToLarge()
				}
			}
			.padding()
			.navigationTitle("Level One")
		}
		.background(
			GeometryReader { proxy in
				Color.white
					.onAppear {
						windowHeight = proxy.size.height
					}
					.ignoresSafeArea()
			}
		)
		.modifier(SetSheetHeight(height: controller.sheetHeight))
		.onAppear {
			if controller.sheetHeight == 0 {
				DispatchQueue.main.async {
					controller.primeInitialHeight()
				}
			}
		}
	}
}

// MARK: - Sheet Level 2 (CTA Owns Heights)

struct DragResizableSheetDetailView: View {
	
	let setHeight: (CGFloat) -> Void
	let setMedium: () -> Void
	let setLarge: () -> Void
	let dismiss: () -> Void
	
	var body: some View {
		VStack(spacing: 20) {
			
			Button("Compact – 400pt") {
				setHeight(400)
			}
			
			Button("Payment Review – 460pt") {
				setHeight(460)
			}
			
			Button("Confirmation – 580pt") {
				setHeight(580)
			}
			
			Divider()
			
			Button("Snap to Medium") {
				setMedium()
			}
			
			Button("Expand to Large") {
				setLarge()
			}
			
			Divider()
		}
		.padding()
		.navigationTitle("Level 2 : Controls")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: dismiss) {
					Image(systemName: "xmark")
				}
				.buttonStyle(.plain)
			}
			
			ToolbarItem(placement: .topBarLeading) {
				AvatarStackView(circleSize: 42, shouldCutout: false)
			}
		}
	}
}

// MARK: - Animatable Height Modifier

fileprivate struct SetSheetHeight: ViewModifier, Animatable {
	
	var height: CGFloat
	
	var animatableData: CGFloat {
		get { height }
		set { height = newValue }
	}
	
	func body(content: Content) -> some View {
		content.presentationDetents(
			height == 0
			? [.medium]
			: [.height(height)]
		)
	}
}

#Preview {
	DragResizableSheetLauncherView()
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
