import SwiftUI

struct DonutSelectionInfoView: View {
	@Bindable var mainContext: DonutChartContext
	@State private var previousIndex: Int = 0
	@State private var direction: CGFloat = 1
	
	var body: some View {
		let selectedIndex = mainContext.model.processedData.firstIndex {
			$0.name == mainContext.interaction.selectedData?.name
		} ?? 0
		
		VStack {
			if let selected = mainContext.interaction.selectedData {
				VStack {
					HStack(alignment: .top) {
						HStack {
							Image(selected.imgPath)
								.resizable()
								.scaledToFill()
								.frame(width: 32, height: 32)
								.clipShape(Circle())
								.id(selected.name)
								.transition(
									.asymmetric(
										insertion: .offset(x: direction * 24)
											.combined(with: .opacity)
											.combined(with: .modifier(
												active: BlurModifier(radius: 8),
												identity: BlurModifier(radius: 0)
											)),
										removal: .offset(x: -direction * 24)
											.combined(with: .opacity)
											.combined(with: .modifier(
												active: BlurModifier(radius: 8),
												identity: BlurModifier(radius: 0)
											))
									)
								)
						}
						.clipped()
						.clipShape(Circle())
						
						Spacer()
						
						VStack(alignment: .trailing, spacing: 4) {
							Image(systemName: "checkmark")
								.font(.system(size: 14, weight: .semibold))
								.foregroundStyle(.black.opacity(0.8))
							
							Text("54%")
								.font(.system(size: 14, weight: .semibold))
								.foregroundStyle(Color.blue)
								.padding(.horizontal, 4)
								.padding(.vertical, 1)
								.background(Capsule().fill(Color.blue.opacity(0.12)))
						}
					}
					
					Text("User Name: \(selected.name)")
						.font(.headline)
					
					Text("CFA \(selected.sales)")
						.font(.title3).fontWeight(.bold)
					
					Button("Clear") {
						withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
							mainContext.interaction.selectedData = nil
						}
					}
					.font(.subheadline)
					.foregroundStyle(.secondary)
				}
				.padding(.vertical, 4)
			} else {
				Text("Tap a segment")
					.foregroundStyle(.secondary)
					.transition(.opacity)
			}
			
			// Dot indicator
			HStack(spacing: 2) {
				ForEach(mainContext.model.processedData.indices, id: \.self) { index in
					let distance = abs(index - selectedIndex)
					let width   = max(6, 12 - CGFloat(distance) * 6)
					let height  = max(4,  8 - CGFloat(distance))
					let opacity = max(0.1, 1.0 - Double(distance) * 0.3)
					
					Capsule()
						.fill(Color.black.opacity(opacity))
						.frame(width: width, height: height)
						.animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedIndex)
				}
			}
		}
		.frame(width: 124, height: 142)
		.padding(.horizontal, 12)
		.padding(.vertical, 4)
		.background(
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(Color(.systemBackground))
		)
		.shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
		// ✅ Update direction BEFORE animation runs
		.onChange(of: selectedIndex) { oldValue, newValue in
			direction = newValue >= oldValue ? -1 : 1
			previousIndex = newValue
		}
		.animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedIndex)
	}
}

// ✅ Custom blur modifier so it works inside .transition(.modifier(...))
struct BlurModifier: ViewModifier {
	let radius: CGFloat
	func body(content: Content) -> some View {
		content.blur(radius: radius)
	}
}
