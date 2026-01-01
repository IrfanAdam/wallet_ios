import SwiftUI

struct PeripheralLaunchSurface: View {
	@State private var isAuxiliaryPlanePresented: Bool = false
	@State private var activeDetent: PresentationDetent = .medium
	
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
			AuxiliaryPresentationPlane(activeDetent: $activeDetent)
				.presentationDetents(
					[.medium, .height(600), .large],
					selection: $activeDetent
				)
				.presentationContentInteraction(.resizes)
				.presentationBackground(Color.black)
		}
	}
}

struct AuxiliaryPresentationPlane: View {
	@Binding var activeDetent: PresentationDetent
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Auxiliary Plane Active")
				.font(.headline)
				.foregroundColor(.white)
			
			HStack(spacing: 12) {
				Button("Medium") {
					activeDetent = .medium
				}
				
				Button("Tall") {
					activeDetent = .height(600)
				}
				
				Button("Large") {
					activeDetent = .large
				}
			}
			.buttonStyle(.borderedProminent)
		}
		.padding(32)
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
		.ignoresSafeArea()
		.background(Color.black)
	}
}

#Preview {
	PeripheralLaunchSurface()
}
