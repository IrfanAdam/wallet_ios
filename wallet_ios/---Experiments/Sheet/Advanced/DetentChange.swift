import SwiftUI

// MARK: - Labeled Detent Model

struct SheetDetentSpec: Identifiable, Hashable {
	let id: String
	let height: CGFloat
}

// MARK: - Root View

struct DetentSnapProbeRootView: View {

	@State private var isSheetVisible = false
	@State private var activeDetent: PresentationDetent = .medium
	@State private var activeDetentID: SheetDetentSpec.ID? = nil

	@State private var customDetents: [SheetDetentSpec] = [
		.init(id: "l2", height: 420),
		.init(id: "l3", height: 500),
		.init(id: "l4", height: 600)
	]

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
			// Reset to .large when sheet closes
			activeDetent = .large
		} content: {
			DetentSnapProbeSheetView(
				detentSelection: $activeDetent,
				activeDetentID: $activeDetentID,
				customDetents: customDetents,
				setCustomDetent: setCustomDetent,
				updateDetentHeight: updateDetentHeight
			)
			.presentationDetents(
				Set(
					[.medium]
					+ customDetents.map { .height($0.height) }
					+ [.large]
				),
				selection: $activeDetent
			)
			.presentationBackground(Color.white)
		}
	}

	private func setCustomDetent(id: SheetDetentSpec.ID) {
		guard let spec = customDetents.first(where: { $0.id == id }) else { return }

		withAnimation(.easeInOut(duration: 0.25)) {
			activeDetentID = id
			activeDetent = .height(spec.height)
		}
	}

	private func updateDetentHeight(id: String, newHeight: CGFloat) {
		guard let index = customDetents.firstIndex(where: { $0.id == id }) else { return }
		customDetents[index] = SheetDetentSpec(id: id, height: newHeight)

		// If this is the active detent, update it
		if activeDetentID == id {
			activeDetent = .height(newHeight)
		}
	}
}

// MARK: - Preference Keys

struct ContentHeightKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - Sheet Content

struct DetentSnapProbeSheetView: View {

	@Binding var detentSelection: PresentationDetent
	@Binding var activeDetentID: SheetDetentSpec.ID?

	let customDetents: [SheetDetentSpec]
	let setCustomDetent: (SheetDetentSpec.ID) -> Void
	let updateDetentHeight: (String, CGFloat) -> Void

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
					LevelTwoContent(
						detentSelection: $detentSelection,
						activeDetentID: $activeDetentID,
						customDetents: customDetents,
						setCustomDetent: setCustomDetent,
						updateDetentHeight: updateDetentHeight
					)
				}

				ForEach(customDetents) { detent in
					Button("Switch to \(detent.id.capitalized)") {
						setCustomDetent(detent.id)
					}
					.buttonStyle(.bordered)
				}

				Button("Switch to Medium") {
					activeDetentID = nil
					detentSelection = .medium
				}
				.buttonStyle(.borderedProminent)

				Button("Switch to Large") {
					activeDetentID = nil
					detentSelection = .large
				}
				.buttonStyle(.borderedProminent)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.navigationTitle("Level One")
			.navigationBarTitleDisplayMode(.inline)
		}
	}

	private var detentLabel: String {
		if let id = activeDetentID {
			return id.capitalized
		}

		switch detentSelection {
		case .medium: return "Medium"
		case .large: return "Large"
		default: return "Custom"
		}
	}
}

// MARK: - Level Two Content

struct LevelTwoContent: View {

	@Binding var detentSelection: PresentationDetent
	@Binding var activeDetentID: SheetDetentSpec.ID?

	let customDetents: [SheetDetentSpec]
	let setCustomDetent: (SheetDetentSpec.ID) -> Void
	let updateDetentHeight: (String, CGFloat) -> Void

	@State private var hasMeasured = false
	@State private var measuredHeight: CGFloat = 0

	var body: some View {
		NavigationStack {
			VStack(spacing: 16) {
				Text("You're in the wrong place!")

				Button("Switch to Medium") {
					activeDetentID = nil
					detentSelection = .medium
				}
				.buttonStyle(.borderedProminent)

				Button("Switch to Large") {
					activeDetentID = nil
					detentSelection = .large
				}
				.buttonStyle(.borderedProminent)

				HStack {
					ForEach(customDetents) { detent in
						Button("Size \(detent.id.capitalized)") {
							setCustomDetent(detent.id)
						}
						.buttonStyle(.bordered)
					}
				}

				// Debug info
				Text("Measured Height: \(Int(measuredHeight)) pt")
					.font(.footnote)
					.foregroundColor(.gray)
			}
			.padding(.horizontal)
			.padding(.top)
			.background(
				GeometryReader { geometry in
					Color.clear
						.onAppear {
							let insets: UIEdgeInsets =
							UIApplication.shared.connectedScenes
								.compactMap { $0 as? UIWindowScene }
								.flatMap { $0.windows }
								.first { $0.isKeyWindow }?
								.safeAreaInsets ?? .zero

							let topInset = insets.top
							let bottomInset = insets.bottom

							let contentHeight = geometry.size.height
							guard !hasMeasured, contentHeight > 0 else {
								return
							}
							hasMeasured = true
							measuredHeight = contentHeight + topInset + bottomInset
							updateDetentHeight("l2", measuredHeight)
						}
				}.ignoresSafeArea()
			)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.navigationTitle("Level Two")
			.navigationBarTitleDisplayMode(.large)
		}
	}
}

// MARK: - Preview

#Preview {
	DetentSnapProbeRootView()
}
