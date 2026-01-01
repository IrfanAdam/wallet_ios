import SwiftUI

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
				
			}
			.navigationTitle("Level One")
			.navigationBarTitleDisplayMode(.inline)
			.background(Color.blue)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.ignoresSafeArea()
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
