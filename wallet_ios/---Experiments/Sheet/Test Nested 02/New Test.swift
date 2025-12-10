import SwiftUI

struct ContentView: View {
	@State private var showSheet = false
	@State private var sheetHeight: CGFloat = 200
	@State private var currentView: SheetViewType = .viewA
	
	var body: some View {
		Button("Open Sheet") {
			showSheet = true
		}
		.sheet(isPresented: $showSheet) {
			SheetContainer(currentView: $currentView,
										 sheetHeight: $sheetHeight)
			.smoothSheetHeight($sheetHeight)
		}
	}
}

// MARK: - View Types
enum SheetViewType: CaseIterable {
	case viewA, viewB, viewC
}

// MARK: - Sheet Container (bottom-aligned fix)
struct SheetContainer: View {
	@Binding var currentView: SheetViewType
	@Binding var sheetHeight: CGFloat

	var body: some View {
		VStack(spacing: 0) {

			// Content
			Group {
				switch currentView {
				case .viewA: ViewA().transition(.blurReplace)
				case .viewB: ViewB().transition(.blurReplace)
				case .viewC: ViewC().transition(.blurReplace)
				}
			}

			// Controls stay fixed at bottom visually
			Picker("Views", selection: $currentView) {
				Text("A").tag(SheetViewType.viewA)
				Text("B").tag(SheetViewType.viewB)
				Text("C").tag(SheetViewType.viewC)
			}
			.pickerStyle(.segmented)
			.padding(.horizontal)
			.padding(.bottom, 14)
		}
		.measureH($sheetHeight)
		.animation(.easeInOut(duration: 0.16), value: currentView)
		.animation(.easeInOut(duration: 0.24), value: sheetHeight)
	}
}

// MARK: - Sample Views
struct ViewA: View {
	var body: some View {
		Color.blue.opacity(0.48)
			.frame(height: 150)
			.overlay(Text("View A – 150px"))
			.cornerRadius(12)
			.padding()
	}
}

struct ViewB: View {
	var body: some View {
		Color.green.opacity(0.48)
			.frame(height: 300)
			.overlay(Text("View B – 300px"))
			.cornerRadius(12)
			.padding()
	}
}

struct ViewC: View {
	var body: some View {
		Color.orange.opacity(0.48)
			.frame(height: 540)
			.overlay(Text("View C – 540px"))
			.cornerRadius(12)
			.padding()
	}
}

// MARK: - Height Measurement
extension View {
	func measureH(_ height: Binding<CGFloat>) -> some View {
		background(
			GeometryReader { geo in
				Color.clear
					.onAppear { height.wrappedValue = geo.size.height }
					.onChange(of: geo.size.height) { _, new in
						height.wrappedValue = new
					}
			}
		)
	}
}

struct SmoothSheetController: UIViewControllerRepresentable {
	@Binding var height: CGFloat
	@State private var controller = UIViewController()
	
	func makeUIViewController(context: Context) -> UIViewController {
		controller.view.backgroundColor = .clear
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		guard let sheet = uiViewController.sheetPresentationController else { return }
		
		let target = max(height, 100)
		
		sheet.animateChanges {
			let dynamicDetent = UISheetPresentationController.Detent.custom(
				identifier: .init("dynamic-detent")
			) { context in
				return target
			}
			
			sheet.detents = [dynamicDetent]
			sheet.largestUndimmedDetentIdentifier = nil
			sheet.prefersGrabberVisible = true
		}
	}
}

// MARK: - Modifier
extension View {
	func smoothSheetHeight(_ height: Binding<CGFloat>) -> some View {
		background(SmoothSheetController(height: height))
	}
}

// MARK: - Preview
#Preview {
	ContentView()
}
