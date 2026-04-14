import SwiftUI
import Foundation

struct DonutSelectionInfoView: View {
	@Bindable var mainContext: DonutChartContext
	@State private var previousIndex: Int = 0
	@State private var direction: CGFloat = 1

	var body: some View {
		let data = mainContext.animation.animatedData

		let selectedIndex: Int? = mainContext.interaction.selectedData.flatMap { selected in
			data.firstIndex { $0.name == selected.name }
		}

		let displayIndex = selectedIndex ?? previousIndex  // use for dots + direction math
		let resolvedDirection: CGFloat = (selectedIndex ?? previousIndex) >= previousIndex ? 1 : -1

		let offset: CGFloat = 32


		let totalSales = mainContext.animation.animatedData.reduce(0) { $0 + $1.sales }

		let percentage: Double = {
			guard totalSales > 0,
						let selected = mainContext.interaction.selectedData else { return 0 }
			return (selected.sales / totalSales) * 100
		}()

		VStack {
			if let selected = mainContext.interaction.selectedData {
				var currencySymbol: String {
					let formatter = NumberFormatter()
					formatter.numberStyle = .currency
					formatter.currencyCode = "XOF"
					return formatter.currencySymbol
				}

				var amountText: String {
					let formatter = NumberFormatter()
					formatter.numberStyle = .decimal
					formatter.maximumFractionDigits = 0
					return formatter.string(from: NSNumber(value: selected.sales)) ?? ""
				}

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
										insertion: .offset(x: resolvedDirection * offset)
											.combined(with: .opacity)
											.combined(with: .modifier(
												active: BlurModifier(radius: 8),
												identity: BlurModifier(radius: 0)
											)),
										removal: .offset(x: -resolvedDirection * offset)
											.combined(with: .opacity)
											.combined(with: .modifier(
												active: BlurModifier(radius: 8),
												identity: BlurModifier(radius: 0)
											))
									)
								)
						}
						.clipShape(Circle())
						.compositingGroup()

						Spacer()
						
						VStack(alignment: .trailing, spacing: 4) {
							Image(systemName: "checkmark")
								.font(.system(size: 14, weight: .semibold))
								.foregroundStyle(.black.opacity(0.8))
							
							Text(percentage.formatted(.number.precision(.fractionLength(0))) + "%")
								.font(.system(size: 14, weight: .semibold))
								.foregroundStyle(Color.blue)
								.padding(.horizontal, 4)
								.padding(.vertical, 1)
								.background(Capsule().fill(Color.blue.opacity(0.12)))
								.contentTransition(.numericText(value: percentage))
								.animation(.spring(response: 0.7, dampingFraction: 0.9), value: percentage)
						}
					}
					
					Text("\(selected.name)")
						.font(.system(size: 16, weight: .bold))
						.id(selected.name)
						.transition(
							.asymmetric(
								insertion: .offset(x: resolvedDirection * offset)
									.combined(with: .opacity)
									.combined(with: .modifier(
										active: BlurModifier(radius: 8),
										identity: BlurModifier(radius: 0)
									)),
								removal: .offset(x: -resolvedDirection * offset)
									.combined(with: .opacity)
									.combined(with: .modifier(
										active: BlurModifier(radius: 8),
										identity: BlurModifier(radius: 0)
									))
							)
						)
						.animation(.spring(response: 0.25, dampingFraction: 0.7), value: selectedIndex)

//					Text("\(selected.sales.formatted(.currency(code: "XOF")))")
//						.font(.custom("OpenRunde-Bold", size: 18))
//						.font(.system(size: 16, weight: .bold))
//						.contentTransition(.numericText(value: selected.sales))
//						.animation(.spring(response: 0.45, dampingFraction: 0.85), value: selected.sales)

					HStack(alignment: .firstTextBaseline, spacing: 2) {
						Text(currencySymbol)
							.font(.custom("OpenRunde-Bold", size: 18))
							.foregroundStyle(.gray.opacity(0.8))

						Text(amountText)
							.font(.custom("OpenRunde-Bold", size: 18))
					}
					.contentTransition(.numericText(value: selected.sales))
					.animation(.spring(response: 0.45, dampingFraction: 0.85), value: selected.sales)

					Button("Clear") {
						withAnimation(.spring(response: 0.36, dampingFraction: 0.6)) {
							mainContext.interaction.selectedData = nil
						}
					}
					.font(.subheadline)
					.foregroundStyle(.secondary)
				}
				.padding(.vertical, 4)
				
				// Dot indicator
				HStack(spacing: 2) {
					ForEach(mainContext.animation.animatedData.indices, id: \.self) { index in
						let distance = abs(index - displayIndex)
						let width   = max(6, 12 - CGFloat(distance) * 6)
						let height  = max(4,  8 - CGFloat(distance))
						let opacity = max(0.1, 1.0 - Double(distance) * 0.3)
						
						Capsule()
							.fill(Color.black.opacity(opacity))
							.frame(width: width, height: height)
							.animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedIndex)
					}
				}
				
			} else {
				Text("Tap a segment")
					.foregroundStyle(.secondary)
					.transition(.opacity)
			}
			
		}
		.frame(width: 124, height: 142)
		.padding(.horizontal, 10)
		.padding(.vertical, 4)
		.background(
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(Color(.systemBackground))
		)
		.clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
		.shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
		// ✅ Update direction BEFORE animation runs
		.onChange(of: selectedIndex) { oldValue, newValue in
			if let newValue {
				previousIndex = newValue
			}
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
