import SwiftUI

#Preview("Toolbar Full-Height Circles – Auto Width") {
	ToolbarFullHeightCirclesDemo()
}

struct ToolbarFullHeightCirclesDemo: View {
	@State private var isAuxiliaryPlanePresented = false
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Text("Content Area")
				Button("Open Sheet") {
					isAuxiliaryPlanePresented.toggle()
				}
				Spacer()
			}
			.navigationTitle("Demo")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
//					FullHeightCircles()
					FullHeightCirclesCutout().drawingGroup()
				}
			}
		}
		.sheet(isPresented: $isAuxiliaryPlanePresented) {
			NavigationStack {
				Text("Sheet Area")
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							//					FullHeightCircles()
							FullHeightCirclesCutout()
						}
					}
			}
			.presentationDetents([.medium, .large])   // 👈 This is the key
			.presentationDragIndicator(.visible)
		}
	}
}

struct FullHeightCircles: View {
	private let count = 3

	@State private var height: CGFloat = 0
	@State private var overlap: CGFloat = 0.2   // 0 → 1
	@State private var animateSpace: Bool = false   // 0 → 1

	private var spacing: CGFloat {
		-height * overlap
	}

	private var totalWidth: CGFloat {
		(height * CGFloat(count)) +
		(spacing * CGFloat(count - 1))
	}

	@State private var stackWidth: CGFloat = 0

	var body: some View {
		GeometryReader { proxy in
			let newHeight = proxy.size.height

			HStack(spacing: spacing) {
				ForEach(0..<count, id: \.self) { index in
					HStack {
						Text("\(index)")
							.foregroundStyle(.white)
							.frame(width: newHeight, height: newHeight)
					}
					.background(
						Circle()
							.fill(Color.blue)
							.frame(width: newHeight, height: newHeight)
					)
					.frame(width: newHeight, height: newHeight, alignment: .center)
					.onAppear {
						print("Appeared index:", index)
					}
					.opacity(animateSpace ? 1 : 0)
					.offset(x: animateSpace ? 0 : -(newHeight + spacing) * CGFloat(index) * 0.5)
				}
			}
			.onAppear {
				if height == 0 {
					height = newHeight
				}
			}
			.onChange(of: newHeight) { _, value in
				height = value
			}
		}
		.onChange(of: height) { _, value in
			stackWidth = totalWidth
			animateSpace = false
			withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
				animateSpace = true
			}
		}
		.frame(width: stackWidth)
		.background(Capsule().fill(Color.black.opacity(0.4)))
	}
}


struct FullHeightCirclesCutout: View {
	private let count = 3

	@State private var height: CGFloat = 0
	@State private var overlap: CGFloat = 0.12
	@State private var animateSpace: Bool = false
	@State private var stackWidth: CGFloat = 0

	private var spacing: CGFloat {
		-height * overlap
	}

	private var totalWidth: CGFloat {
		(height * CGFloat(count)) +
		(spacing * CGFloat(count - 1)) + padded * 2
	}

	private let padded: CGFloat = 4

	var body: some View {
		GeometryReader { proxy in
			let newHeight = proxy.size.height - padded * 2

			HStack(spacing: spacing) {
				ForEach(0..<count, id: \.self) { index in
					Circle()
						.fill(Color.blue)
						.frame(width: newHeight, height: newHeight)
						.overlay {
							// Cutout from previous circle
							if index < count - 1 {
								Circle()
									.frame(width: newHeight + padded/2 , height: newHeight + padded/2)
									.offset(x: (newHeight - padded) * (1 - overlap))
									.blendMode(.destinationOut)
							}
						}
						.opacity(animateSpace ? 1 : 0)
						.offset(x: animateSpace ? 0 : -(newHeight + spacing) * CGFloat(index) * 0.5)
						.compositingGroup()
				}
			}
			.onAppear {
				if height == 0 {
					height = newHeight
				}
			}
			.onChange(of: newHeight) { _, value in
				height = value
			}
			.padding(padded)
		}
		.onChange(of: height) { _, _ in
			stackWidth = totalWidth
			animateSpace = false
			withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
				animateSpace = true
			}
		}
		.drawingGroup()
		.frame(width: stackWidth)
		.fixedSize(horizontal: true, vertical: false)
		.background(
			Capsule()
				.fill(Color.black.opacity(0.9))
		)
	}
}
