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
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
			.presentationBackground(Color.white)
		}
	}

	// Smoothly update the detent
	private func setCustomDetent(height: CGFloat) {
		// Step 1: Animate to intermediate custom height
		withAnimation(.easeInOut(duration: 0.25)) {
			currentCustomHeight = height
			activeDetent = .height(height)
		}
	}

	// Smooth transition to medium/large
	private func setFinalDetent(_ detent: PresentationDetent) {
		guard detent != .height(currentCustomHeight ?? 0) else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
			activeDetent = detent
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
			VStack(spacing: 12) {

				VStack(spacing: 8) {
					Text("Current Detent")
						.font(.headline)

					Text(detentLabel)
						.font(.title2)
						.bold()
				}

				NavigationLink("Go to Level Two") {
					VStack {
						Text("You're in the wrong place!")
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
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
					.background(Color.white)
					.navigationTitle("Level Two")
					.navigationBarTitleDisplayMode(.inline)
				}

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
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.navigationTitle("Level one")
			.navigationBarTitleDisplayMode(.inline)
		}
		.padding(0)
		.ignoresSafeArea()
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
