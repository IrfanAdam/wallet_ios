import SwiftUI

// MARK: - Labeled Detent Model

struct SheetDetentSpec: Identifiable, Hashable {
	let id: String
	let height: CGFloat
}

// MARK: - Preference Keys

struct ContentHeightKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
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
			.presentationBackground(.clear)
		}
	}

	private func setCustomDetent(id: SheetDetentSpec.ID) {
		guard let spec = customDetents.first(where: { $0.id == id }) else { return }
		activeDetentID = id
		activeDetent = .height(spec.height)

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

#Preview {
	DetentSnapProbeRootView()
}
