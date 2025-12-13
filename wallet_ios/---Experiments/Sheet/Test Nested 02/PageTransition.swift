import SwiftUI

struct SeamlessPageNavDemo: View {
	var body: some View {
		NavigationStack {
			FirstPage()
		}
	}
}

struct FirstPage: View {
	@Namespace private var ns

	var body: some View {
		NavigationStack {
			NavigationLink {
				SecondPage(namespace: ns)
					.navigationTransition(.zoom(sourceID: "button", in: ns))
			} label: {
				Text("Go to Details")
					.frame(maxWidth: .infinity)
					.padding()
					.background(.blue)
					.foregroundStyle(.white)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.matchedTransitionSource(id: "button", in: ns)
			}
			.buttonStyle(.plain)
		}
		.padding()
		.navigationTitle("Page One")
		.navigationBarTitleDisplayMode(.large)
	}
}

struct SecondPage: View {
	let namespace: Namespace.ID

	var body: some View {
		VStack(spacing: 20) {
			RoundedRectangle(cornerRadius: 16)
				.fill(.blue)
				.frame(width: 360, height: 480)
		}
		.navigationTitle("Page Two")
	}
}

#Preview {
	SeamlessPageNavDemo()
}
