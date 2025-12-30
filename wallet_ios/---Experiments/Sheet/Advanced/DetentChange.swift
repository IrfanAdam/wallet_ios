import SwiftUI

// MARK: - Root View

struct DetentSnapProbeRootView: View {

	@State private var isSheetVisible = false
	@State private var activeDetent: PresentationDetent = .medium
	@State private var currentCustomHeight: CGFloat? = nil // Track current custom height

	// Array of custom heights
	private let customHeights: [CGFloat] = [420, 500, 600]

	var body: some View {
		VStack(spacing: 32) {
			Text("Detent Snap Probe")
				.font(.largeTitle)

			Button("Open Sheet") {
				isSheetVisible = true
			}
			.buttonStyle(.borderedProminent)


			Spacer()
		}
		.sheet(isPresented: $isSheetVisible) {
			DetentSnapProbeSheetView(
				detentSelection: $activeDetent,
				customHeights: customHeights,
				currentCustomHeight: $currentCustomHeight,
				setCustomDetent: setCustomDetent
			)
			.presentationDetents(
				Set([.medium] + customHeights.map { .height($0) } + [.large]),
				selection: $activeDetent
			)
			.presentationDragIndicator(.hidden)
			.interactiveDismissDisabled(true)
			.presentationBackground(Color.black)
		}
	}

	// Smoothly update the detent
	private func setCustomDetent(height: CGFloat) {
		// Step 1: keep detent at current height to allow animation
		if let current = currentCustomHeight {
			activeDetent = .height(current)
		}

		// Step 2: animate to new height after tiny delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
			withAnimation(.easeInOut(duration: 0.25)) {
				currentCustomHeight = height
				activeDetent = .height(height)
			}
		}
	}
}

// MARK: - Sheet Content

struct DetentSnapProbeSheetView: View {

	@Binding var detentSelection: PresentationDetent
	let customHeights: [CGFloat]
	@Binding var currentCustomHeight: CGFloat?
	let setCustomDetent: (CGFloat) -> Void

	@State private var controller = AppSheetController()

	var body: some View {
		NavigationStack {
			VStack(spacing: 28) {

				Text("Sheet Test Area")
					.font(.title)

				VStack(spacing: 8) {
					Text("Current Detent")
						.font(.headline)

					Text(detentLabel)
						.font(.title2)
						.bold()
				}

				Divider()

				// Buttons to switch heights
				ForEach(customHeights, id: \.self) { height in
					Button("Switch to Custom (\(Int(height))pt)") {
						setCustomDetent(height)
					}
					.buttonStyle(.bordered)
				}

				Button("Switch to Medium") {
					detentSelection = .medium
					currentCustomHeight = nil
				}
				.buttonStyle(.borderedProminent)

				Button("Switch to Large") {
					detentSelection = .large
					currentCustomHeight = nil
				}
				.buttonStyle(.borderedProminent)

				Spacer()
			}
		}
		.padding()
		.frame(maxHeight: .infinity, alignment: .top)
		.navigationBarTitleDisplayMode(.inline)
		.toolbarVisibility(.hidden)
		.ignoresSafeArea()
		.animation(.easeInOut(duration: 0.25), value: detentSelection)
	}

	// Show label safely without pattern matching
	private var detentLabel: String {
		switch detentSelection {
		case .medium: return "Medium"
		case .large: return "Large"
		default:
			if let h = currentCustomHeight {
				return "Custom \(Int(h))pt"
			} else {
				return "Custom Height"
			}
		}
	}
}

#Preview {
	DetentSnapProbeRootView()
}
