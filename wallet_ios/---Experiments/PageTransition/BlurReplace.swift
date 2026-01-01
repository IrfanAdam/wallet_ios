import SwiftUI

struct SeamlessNavDemo: View {
	// State to toggle between the two "pages" of content
	@State private var currentPageIsOne = true

	var body: some View {
		// Use a single VStack or ZStack to hold the content
		VStack {
			if currentPageIsOne {
				PageOneContent(currentPageIsOne: $currentPageIsOne)
				// Apply the blur/fade effect to the whole content block
					.transition(.blurReplace)
			} else {
				PageTwoContent(currentPageIsOne: $currentPageIsOne)
				// Apply the blur/fade effect to the whole content block
					.transition(.blurReplace)
			}
		}
		.animation(.easeInOut(duration: 0.2), value: currentPageIsOne) // Animate the state change
		// Add padding/background to simulate a container/screen
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
	}
}

// First Page Content (Renamed to avoid conflict with previous structs)
struct PageOneContent: View {
	@Binding var currentPageIsOne: Bool

	var body: some View {
		VStack(spacing: 20) {
			Text("This is Page One")
				.font(.title)

			Button("Go to Details") {
				// Toggle the state to switch content
				currentPageIsOne.toggle()
			}
			.buttonStyle(.borderedProminent)
		}
		.navigationTitle("Page One") // NavigationTitle won't appear without a NavigationStack
	}
}

// Second Page Content (Renamed)
struct PageTwoContent: View {
	@Binding var currentPageIsOne: Bool

	var body: some View {
		VStack(spacing: 20) {
			Text("This is Page Two")
				.font(.title)

			Button("Go Back") {
				// Toggle the state back
				currentPageIsOne.toggle()
			}
			.buttonStyle(.borderedProminent)
		}
		.navigationTitle("Page Two")
	}
}

// Extension to define the custom blurReplace transition (iOS 17.0+)
extension AnyTransition {
	static var blurReplace: AnyTransition {
		// Combines a fade (opacity) with a simultaneous blur
		AnyTransition.opacity.animation(.easeInOut(duration: 0.4))
		// Or for the standard SwiftUI blurReplace (requires iOS 17.0+):
		// return AnyTransition.identity.animation(.easeInOut).blurReplace()
		// If blurReplace() is unavailable, the manual opacity/blur works:
		// return .asymmetric(
		//     insertion: .opacity.combined(with: .blur),
		//     removal: .opacity.combined(with: .blur)
		// )
	}
}


#Preview {
	SeamlessNavDemo()
}
