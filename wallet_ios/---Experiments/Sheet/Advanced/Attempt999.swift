import SwiftUI
import Observation

// MARK: - Height Variant Model

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

struct SheetGeometry {
	let size: CGSize
	let safeAreaInsets: EdgeInsets
}

@Observable
final class SheetMetrics {

	var height: CGFloat = 0
	var size: CGSize = .zero
	var safeAreaInsets: EdgeInsets = .init()


}



// MARK: - Root View

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented: Bool = false

	// UIKit-backed selection
	@State private var activeDetent: PresentationDetent

	@State private var sheetMetrics = SheetMetrics()

	// Ring of detents (acts like a buffer)
	@State private var heightVariants: [HeightVariant] = [
		.init(id: "s", height: 140),
		.init(id: "m", height: 320),
		.init(id: "l", height: 720)
	]

	// Track which slot is currently selected
	@State private var activeIndex: Int = 1

	init() {
		_activeDetent = State(initialValue: .height(240))
	}

	var body: some View {
		VStack(spacing: 24) {
			Text("Primary Interaction Surface")
				.font(.title2)

			Button("Invoke Secondary Plane") {
				isAuxiliaryPlanePresented.toggle()
			}
		}
		.padding()
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				GeometryReader { contentProxy in
					let sheetGeometry = SheetGeometry(
						size: contentProxy.size,
						safeAreaInsets: contentProxy.safeAreaInsets
					)
					AuxiliaryPresentationPlane(
						heightVariants: $heightVariants,
						activeIndex: $activeIndex,
						activeDetent: $activeDetent,
						sheetGeometry: sheetGeometry
					)
				}
			}
			.frame(height: sheetMetrics.height)
			.environment(sheetMetrics)
			.presentationDetents(
				Set(heightVariants.map { .height($0.height) } + [/*.medium, */.large]),
				selection: $activeDetent
			)
			.presentationBackground(Color.white)
			.presentationDragIndicator(.hidden)
		}
	}
}

// MARK: - Sheet Content

struct AuxiliaryPresentationPlane: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent

	@Environment(SheetMetrics.self) private var sheetMetrics

	@State private var contentHeight: CGFloat = 0
	let sheetGeometry: SheetGeometry

	@State private var contentOpacity: Double = 0

	@Namespace private var navNamespace
	private let zoomID = "levelTwoZoom"

	@State private var navigateToL2 = false


	var body: some View {

		VStack(spacing: 20) {

			HStack(spacing: 12) {
				ForEach(heightVariants.indices, id: \.self) { index in
					Button(heightVariants[index].id.capitalized) {
						select(index)
					}
					.buttonStyle(.borderedProminent)
				}

				Button("Native Large") {
					activeDetent = .large
				}
			}

			Button("Go L2") {
				// PREPARE the height first
				rotateAndResize(to: contentHeight)

				// Then navigate in the same run loop
				navigateToL2 = true
			}
			.buttonStyle(.glassProminent)
			.matchedGeometryEffect(id: zoomID, in: navNamespace)
			.navigationDestination(isPresented: $navigateToL2) {
				levelTwo
					.navigationTransition(
						.zoom(sourceID: zoomID, in: navNamespace)
					)
//					.navigationTransition(.automatic)
			}

		}
		.toolbarVisibility(.visible, for: .navigationBar)
		.padding(.horizontal)
		.background(
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						print("proxy:", sheetGeometry)

						let measured =
						proxy.size.height
						+ sheetGeometry.safeAreaInsets.top
						+ sheetGeometry.safeAreaInsets.bottom

						sheetMetrics.height = measured
						contentHeight = measured
					}
			}
		)
		.onAppear() {
			rotateAndResize(to: contentHeight)
		}
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
		.fixedSize(horizontal: false, vertical: true)
		.background(Color.white)
	}

	// MARK: - Level Two

	private var levelTwo: some View {
		VStack(spacing: 12) {
			HStack(spacing: 12) {
				ForEach(heightVariants.indices, id: \.self) { index in
					Button(heightVariants[index].id.capitalized) {
						select(index)
					}
					.buttonStyle(.borderedProminent)
				}
				Button("Native Large") {
					activeDetent = .large
				}

				Button("Content") {
					rotateAndResize(to: contentHeight)
				}
			}

			Button("Resize → 420") {
				rotateAndResize(to: 420)
			}

			Button("Resize → 480") {
				rotateAndResize(to: 480)
			}

			Text("Measured Height: \(Int(contentHeight)) pt")
				.font(.footnote)
				.foregroundColor(.gray)

			HStack(spacing: 8) {
				Button("Previous") {

				}
				.buttonStyle(.bordered)
				.buttonSizing(.flexible)
				.controlSize(.large)

				Button("Next") {

				}
				.buttonStyle(.borderedProminent)
				.buttonSizing(.flexible)
				.controlSize(.large)
			}
			.padding(.horizontal, 8)
			.offset(y: sheetGeometry.safeAreaInsets.bottom/3)
		}
		.opacity(contentOpacity)
		.padding(.horizontal)
		.padding(.vertical, 0)
		.background(
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						print("proxy:", sheetGeometry)
						let measured =
						proxy.size.height
						+ sheetGeometry.safeAreaInsets.top
						sheetMetrics.height = measured
						contentHeight = measured + sheetGeometry.safeAreaInsets.bottom
					}
			}
		)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
		.navigationTitle("Look ma we made it")
		.task {
			rotateAndResize(to: contentHeight)
			try? await Task.sleep(nanoseconds: 1000_000_000) // 1.0 seconds
			withAnimation(.easeIn(duration: 0.35)) {
				contentOpacity = 1
			}
		}
		.onDisappear {
			contentOpacity = 0
		}
		.background(Color.white)
	}

	// MARK: - Helpers

	private func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	private func rotateAndResize(to newHeight: CGFloat) {
		let nextIndex = (activeIndex + 1) % heightVariants.count

		withAnimation(.easeInOut(duration: 0.35)) {
			heightVariants[nextIndex].height = newHeight
			activeIndex = nextIndex
			activeDetent = .height(newHeight)
		}
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
