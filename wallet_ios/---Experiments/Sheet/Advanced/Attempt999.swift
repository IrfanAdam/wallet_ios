import SwiftUI

// MARK: - Height Variant Model

struct HeightVariant: Identifiable, Hashable {
	let id: String
	var height: CGFloat
}

struct SheetGeometry {
	let size: CGSize
	let safeAreaInsets: EdgeInsets
}

// MARK: - Root View

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented: Bool = false

	// UIKit-backed selection
	@State private var activeDetent: PresentationDetent

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
//			NavigationStack {
//				AuxiliaryPresentationPlane(
//					heightVariants: $heightVariants,
//					activeIndex: $activeIndex,
//					activeDetent: $activeDetent
//				)
//			}
//			.presentationDetents(
//				Set(heightVariants.map { .height($0.height) } + [.medium, .large]),
//				selection: $activeDetent
//			)
//			.presentationBackground(Color.white)
//			.presentationDragIndicator(.hidden)


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
			.presentationDetents(
				Set(heightVariants.map { .height($0.height) } + [.medium, .large]),
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

	@State private var contentHeight: CGFloat = 0
	let sheetGeometry: SheetGeometry

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

			NavigationLink("Go L2") {
				levelTwo
			}
			.buttonStyle(.glassProminent)

		}
		.toolbarVisibility(.visible, for: .navigationBar)
		.padding(.horizontal)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
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
				.background(Color.black)
		}
		.padding(.horizontal)
		.background(
			GeometryReader { proxy in
				Color.clear
					.onAppear {
						print("proxy:", sheetGeometry)
						contentHeight = proxy.size.height + sheetGeometry.safeAreaInsets.top + sheetGeometry.safeAreaInsets.bottom
					}
			}
		)
		.fixedSize(horizontal: false, vertical: true)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
		.background(Color.white)
		.navigationTitle("Look ma we made it")
		.onAppear {
			rotateAndResize(to: contentHeight)
		}
	}

	// MARK: - Helpers

	private func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	private func rotateAndResize(to newHeight: CGFloat) {
		let nextIndex = (activeIndex + 1) % heightVariants.count

		heightVariants[nextIndex].height = newHeight
		activeIndex = nextIndex
		activeDetent = .height(newHeight)
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
