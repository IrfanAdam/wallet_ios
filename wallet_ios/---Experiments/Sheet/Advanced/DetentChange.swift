import SwiftUI

// MARK: - Labeled Detent Model

struct SheetDetentSpec: Identifiable, Hashable {
	let id: String
	let height: CGFloat
}

// MARK: - Root View

struct DetentSnapProbeRootView: View {

	@State private var isSheetVisible = false

	// UIKit-backed detent
	@State private var activeDetent: PresentationDetent = .medium

	// Semantic detent intent
	@State private var activeDetentID: SheetDetentSpec.ID? = nil

	// Labeled custom detents
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

	// MARK: - Detent Setter (Semantic → UIKit)

	private func setCustomDetent(id: SheetDetentSpec.ID) {
		guard let spec = customDetents.first(where: { $0.id == id }) else { return }

		withAnimation(.easeInOut(duration: 0.25)) {
			activeDetentID = id
			activeDetent = .height(spec.height)
		}
	}

	// MARK: - Detent Height Updater

	private func updateDetentHeight(id: String, newHeight: CGFloat) {
		guard let index = customDetents.firstIndex(where: { $0.id == id }) else { return }
		customDetents[index] = SheetDetentSpec(id: id, height: newHeight)
	}
}

struct ContentHeightKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

struct NavBarHeightKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - Sheet Content

struct DetentSnapProbeSheetView: View {

	@Binding var detentSelection: PresentationDetent
	@Binding var activeDetentID: SheetDetentSpec.ID?
	@State private var sheetNewHeight: CGFloat = 0
	@State private var hasSetInitialHeight = false

	let customDetents: [SheetDetentSpec]
	let setCustomDetent: (SheetDetentSpec.ID) -> Void
	let updateDetentHeight: (String, CGFloat) -> Void

	@State private var navBarHeight: CGFloat = 0

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

							VStack {
								ForEach(customDetents) { detent in
									Button("Size \(detent.id.capitalized)") {
										setCustomDetent(detent.id)
									}
									.buttonStyle(.bordered)
								}
							}

							// 🔍 Display measured height
							Text("Measured height: \(Int(sheetNewHeight)) pt")
								.font(.footnote)
								.foregroundColor(.gray)

							Text("Measured Nav Height: \(Int(navBarHeight)) pt")
								.font(.footnote)
								.foregroundColor(.gray)

							Text("Sheet Height: \(Int(sheetNewHeight + navBarHeight)) pt")
								.font(.footnote)
								.foregroundColor(.gray)
						}
						.background(
							GeometryReader { proxy in
								Color.clear
								.preference(
									key: ContentHeightKey.self,
									value: proxy.size.height
								)
								.preference(
									key: NavBarHeightKey.self,
									value: proxy.safeAreaInsets.top
								)
							}
							.onPreferenceChange(NavBarHeightKey.self) { safeInset in
								navBarHeight = safeInset
							}
							.onPreferenceChange(ContentHeightKey.self) { newHeight in
								sheetNewHeight = newHeight + navBarHeight
								if !hasSetInitialHeight && newHeight > 0 {
									hasSetInitialHeight = true
									updateDetentHeight("l2", sheetNewHeight)
								}
							}
						)
						.background(Color.white)
						.navigationTitle("Level Two")
						.navigationBarTitleDisplayMode(.large)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				}

				// MARK: - Labeled Custom Detents

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

	// MARK: - Label Resolution

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

// MARK: - Preview

#Preview {
	DetentSnapProbeRootView()
}
