import SwiftUI

// Designed to test single detent variable

// MARK: - Root Test Surface

struct DynamicSheetTestSurface: View {

	@State private var isSheetPresented = false

	// Selected detent (programmatic only)
	@State private var selectedDetent: PresentationDetent = .height(240)

	// Computed custom height (content + chrome)
	@State private var resolvedSheetHeight: CGFloat = 240

	// Whether native large is enabled
	@State private var allowsLargeDetent = false

	var body: some View {
		VStack(spacing: 24) {
			Text("Primary Surface")
				.font(.title2)

			Button("Present Sheet pt 2") {
				isSheetPresented = true
			}
		}
		.padding()
		.sheet(isPresented: $isSheetPresented) {
			NavigationStack {
				SheetContentSurface(
					resolvedSheetHeight: $resolvedSheetHeight,
					allowsLargeDetent: $allowsLargeDetent,
					selectedDetent: $selectedDetent
				)
			}
			.presentationDetents(detents, selection: $selectedDetent)
			.presentationDragIndicator(.hidden)
			.presentationBackground(.white)
		}
	}

	// MARK: - Detents

	private var detents: Set<PresentationDetent> {
		var set: Set<PresentationDetent> = [
			.height(resolvedSheetHeight)
		]
		if allowsLargeDetent {
			set.insert(.large)
		}
		return set
	}
}

// MARK: - Sheet Content

struct SheetContentSurface: View {

	@Binding var resolvedSheetHeight: CGFloat
	@Binding var allowsLargeDetent: Bool
	@Binding var selectedDetent: PresentationDetent

	// Content-only height
	@State private var contentHeight: CGFloat = 0

	// Safe area of the sheet container (measured once)
	@State private var sheetSafeArea: EdgeInsets = .init()

	var body: some View {
		VStack(spacing: 20) {

			NavigationLink("Go Deeper") {
				levelTwo
			}
			.buttonStyle(.glassProminent)

			Button("Force Native Large") {
				allowsLargeDetent = true
				selectedDetent = .large
			}

			Text("Content height: \(Int(contentHeight)) pt")
				.font(.footnote)
				.foregroundColor(.secondary)
		}
		.padding()
		.background(
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						sheetSafeArea = proxy.safeAreaInsets
						reconcileHeight(using: proxy.size.height)
					}
					.onChange(of: proxy.size.height) {
						reconcileHeight(using: proxy.size.height)
					}
			}
		)
		.navigationTitle("Dynamic Sheet")
	}

	// MARK: - Level Two

	private var levelTwo: some View {
		VStack(alignment: .center,spacing: 16) {

			Text("Level Two Content")
				.font(.title3)

			ForEach(0..<3) { index in
				Text("Row \(index)")
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.gray.opacity(0.1))
					.cornerRadius(8)
			}

			HStack(spacing: 8) {
				Button("Previous") {}
					.buttonStyle(.bordered)
					.buttonSizing(.flexible)

				Button("Next") {}
					.buttonStyle(.borderedProminent)
					.buttonSizing(.flexible)
			}
			.controlSize(.large)
		}
		.padding()
		.background(
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						reconcileHeight(using: proxy.size.height)
					}
					.onChange(of: proxy.size.height) {
						reconcileHeight(using: proxy.size.height)
					}
			}
		)
		.navigationTitle("Level Two")
	}

	// MARK: - Height Resolution Logic

	private func reconcileHeight(using contentOnlyHeight: CGFloat) {
		contentHeight = contentOnlyHeight

		let totalHeight =
		contentOnlyHeight
		+ sheetSafeArea.top
		+ sheetSafeArea.bottom + 80

		let largeThreshold: CGFloat = 720

		if totalHeight > largeThreshold {
			if !allowsLargeDetent {
				allowsLargeDetent = true
				selectedDetent = .large
			}
		} else {
			allowsLargeDetent = false
			resolvedSheetHeight = totalHeight

			selectedDetent = .height(totalHeight)
		}
	}
}

// MARK: - Preview

#Preview {
	DynamicSheetTestSurface()
}
