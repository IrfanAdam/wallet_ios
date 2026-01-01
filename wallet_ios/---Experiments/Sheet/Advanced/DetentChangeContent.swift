import SwiftUI

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
				
				Text("Measured Height: \(Int(measuredHeight)) pt")
					.font(.footnote)
					.foregroundColor(.gray)
			}
			.background(
				GeometryReader { geometry in
					Color.white
						.onAppear {
							let insets =
							UIApplication.shared.connectedScenes
								.compactMap { $0 as? UIWindowScene }
								.flatMap { $0.windows }
								.first { $0.isKeyWindow }?
								.safeAreaInsets ?? .zero
							
							let contentHeight = geometry.size.height
							guard !hasMeasured, contentHeight > 0 else { return }
							
							hasMeasured = true
							measuredHeight = contentHeight + insets.top + insets.bottom
							updateDetentHeight("l2", measuredHeight)
						}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.navigationTitle("Level Two")
		.navigationBarTitleDisplayMode(.large)
	}
}
