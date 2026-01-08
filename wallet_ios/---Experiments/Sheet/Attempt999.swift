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

// MARK: - Routing

enum AuxiliaryRoute {
	case levelOne
	case levelTwo
}

// MARK: - Root View

struct PeripheralLaunchSurface: View {

	@State private var isAuxiliaryPlanePresented = false
	@State private var activeDetent: PresentationDetent = .height(240)
	@State private var sheetMetrics = SheetMetrics()

	@State private var heightVariants: [HeightVariant] = [
		.init(id: "s", height: 140),
		.init(id: "m", height: 320),
		.init(id: "l", height: 720)
	]

	@State private var activeIndex: Int = 1
	@State private var route: AuxiliaryRoute = .levelOne

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
					let geometry = SheetGeometry(
						size: contentProxy.size,
						safeAreaInsets: contentProxy.safeAreaInsets
					)

					ZStack {
						if route == .levelOne {
							AuxiliaryPresentationPlane(
								heightVariants: $heightVariants,
								activeIndex: $activeIndex,
								activeDetent: $activeDetent,
								route: $route,
								sheetGeometry: geometry
							)
							.transition(.blurReplace)
						}

						if route == .levelTwo {
							LevelTwoView(
								heightVariants: $heightVariants,
								activeIndex: $activeIndex,
								activeDetent: $activeDetent,
								route: $route,
								sheetGeometry: geometry
							)
							.transition(.blurReplace)
						}
					}
					.animation(.easeInOut(duration: 0.35), value: route)
					.environment(sheetMetrics)
				}
			}
			.toolbar {
				ToolbarItemGroup(placement: .topBarLeading) {
					Button {
//						rotateAndResize(to: 320)
//						dismiss()
					} label: {
						Label("Dismiss", systemImage: "chevron.down")
					}
				}
			}
			.presentationDetents(
				Set(heightVariants.map { .height($0.height) } + [.large]),
				selection: $activeDetent
			)
			.presentationBackground(.white)
			.presentationDragIndicator(.hidden)
		}
	}
}

// MARK: - Level One

struct AuxiliaryPresentationPlane: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent
	@Binding var route: AuxiliaryRoute

	@Environment(SheetMetrics.self) private var sheetMetrics
	@Environment(\.dismiss) private var dismiss

	@State private var contentHeight: CGFloat = 320
	let sheetGeometry: SheetGeometry

	var body: some View {
		VStack(spacing: 20) {

			detentRow

			Button("Go L2") {
				rotateAndResize(to: contentHeight)
				route = .levelTwo
			}
			.buttonStyle(.glassProminent)
		}
		.toolbar {
			ToolbarItem(id: "Morph This", placement: .topBarLeading) {
				Button {
					rotateAndResize(to: 320)
					dismiss()
				} label: {
					Label("Dismiss", systemImage: "chevron.down")
				}
			}
		}
		.padding()
		.background(
			GeometryReader { proxy in
				Color.clear.onAppear {
					let measured =
					proxy.size.height
					+ sheetGeometry.safeAreaInsets.top
					+ sheetGeometry.safeAreaInsets.bottom

					contentHeight = measured
					sheetMetrics.height = measured
				}
			}
		)
		.task(id: contentHeight) {
			guard contentHeight > 0 else { return }
			rotateAndResize(to: contentHeight)
		}
	}

	private var detentRow: some View {
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
	}

	private func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	private func rotateAndResize(to newHeight: CGFloat) {
		let next = (activeIndex + 1) % heightVariants.count
		withAnimation(.easeInOut(duration: 0.35)) {
			heightVariants[next].height = newHeight
			activeIndex = next
			activeDetent = .height(newHeight)
		}
	}
}

// MARK: - Level Two

struct LevelTwoView: View {

	@Binding var heightVariants: [HeightVariant]
	@Binding var activeIndex: Int
	@Binding var activeDetent: PresentationDetent
	@Binding var route: AuxiliaryRoute

	@Environment(SheetMetrics.self) private var sheetMetrics

	@State private var contentHeight: CGFloat = 0
	let sheetGeometry: SheetGeometry

	var body: some View {
		VStack(spacing: 16) {

			detentRow

			Button("Resize → 420") {
				rotateAndResize(to: 420)
			}

			Button("Resize → 480") {
				rotateAndResize(to: 480)
			}

			Text("Measured Height: \(Int(contentHeight)) pt")
				.font(.footnote)
				.foregroundColor(.gray)
		}
		.toolbar {
			ToolbarItem(id: "Morph This", placement: .topBarLeading) {
				Button {
					rotateAndResize(to: contentHeight)
					route = .levelOne
				} label: {
//					Label("Back", systemImage: "chevron.left")
					AvatarStackView(circleSize: 42, shouldCutout: false)
				}
				.padding(.horizontal, -8)
			}
		}
		.padding()
		.background(
			GeometryReader { proxy in
				Color.clear.onAppear {
					let measured =
					proxy.size.height
					+ sheetGeometry.safeAreaInsets.top
					+ sheetGeometry.safeAreaInsets.bottom

					contentHeight = measured
					sheetMetrics.height = measured
				}
			}
		)
		.task(id: contentHeight) {
			guard contentHeight > 0 else { return }
			rotateAndResize(to: contentHeight)
		}
	}

	private var detentRow: some View {
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
	}

	private func select(_ index: Int) {
		activeIndex = index
		activeDetent = .height(heightVariants[index].height)
	}

	private func rotateAndResize(to newHeight: CGFloat) {
		let next = (activeIndex + 1) % heightVariants.count
		withAnimation(.easeInOut(duration: 0.35)) {
			heightVariants[next].height = newHeight
			activeIndex = next
			activeDetent = .height(newHeight)
		}
	}
}

struct BlurModifier: ViewModifier {
	let radius: CGFloat
	func body(content: Content) -> some View {
		content.blur(radius: radius)
	}
}

// MARK: - Preview

#Preview {
	PeripheralLaunchSurface()
}
