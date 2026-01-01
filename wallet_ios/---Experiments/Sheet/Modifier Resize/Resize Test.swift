import SwiftUI

struct ContentView: View {
	@State private var showSheet = false
	@State private var currentView: SheetViewType = .viewA
	
	var body: some View {
		Button("Open Sheet") {
			showSheet = true
		}
		.sheet(isPresented: $showSheet) {
			DynamicSheet() {
				VStack(spacing: 20) {
					Group {
						switch currentView {
						case .viewA: ViewA().transition(.blurReplace)
						case .viewB: ViewB().transition(.blurReplace)
						case .viewC: ViewC().transition(.blurReplace)
						}
					}
					.id(currentView)
					.transition(.blurReplace)
					.animation(.easeInOut(duration: 0.2), value: currentView)
					
					Picker("Views", selection: $currentView) {
						Text("A").tag(SheetViewType.viewA)
						Text("B").tag(SheetViewType.viewB)
						Text("C").tag(SheetViewType.viewC)
					}
					.pickerStyle(.segmented)
					.padding()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
			}
		}
	}
}

// MARK: - View Types
enum SheetViewType: CaseIterable {
	case viewA, viewB, viewC
}

// MARK: - Sheet Container
struct DynamicSheet<Content: View>: View {
	let content: Content
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	@State private var sheetHeight: CGFloat = 200
	
	var windowSize : CGSize {
		if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
			return size
		}
		return .zero
	}

	var body: some View {
		VStack(alignment: .trailing, spacing: 0) {
			content
			.fixedSize(horizontal: false, vertical: true)
			.onGeometryChange(for: CGSize.self) {
				$0.size
			} action: { newValue in
				let newH = min(newValue.height, windowSize.height * 0.9)
				if sheetHeight == .zero {
					sheetHeight = newH
				} else {
					withAnimation(.snappy(duration: 0.25, extraBounce: 0.1)) {
						sheetHeight = newH
					}
				}
			}
		}
		.modifier(SetSheetHeight(height: sheetHeight, screenHeight: windowSize.height))
	}
}

// MARK: - Sample Views
struct ViewA: View {
	var body: some View {
		Color.blue.opacity(0.2)
			.frame(height: 150)
			.overlay(Text("View A – 150px"))
			.cornerRadius(12)
			.padding()
	}
}

struct ViewB: View {
	var body: some View {
		Color.green.opacity(0.2)
			.frame(height: 300)
			.overlay(Text("View B – 300px"))
			.cornerRadius(12)
			.padding()
	}
}

struct ViewC: View {
	var body: some View {
		Color.orange.opacity(0.2)
			.frame(height: 450)
			.overlay(Text("View C – 450px"))
			.cornerRadius(12)
			.padding()
	}
}

// MARK: - Preview
#Preview {
	ContentView()
}
