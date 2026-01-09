import SwiftUI

struct ToolbarContentTransitionDemo: View {
	@Namespace private var ns
	@State private var showSecondScreen = false

	var body: some View {
		NavigationStack {
			ZStack {
				// Content switching
				if !showSecondScreen {
					VStack(spacing: 20) {
						Text("Screen A")
							.font(.largeTitle)
							.matchedGeometryEffect(id: "title", in: ns)

						RoundedRectangle(cornerRadius: 12)
							.fill(Color.blue)
							.frame(height: 200)
							.overlay(Text("Main Content A").foregroundColor(.white))
							.matchedGeometryEffect(id: "content", in: ns)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.35)) {
									showSecondScreen = true
								}
							}
					}
					.transition(.blurReplace)
				} else {
					VStack(spacing: 20) {
						Text("Screen B")
							.font(.largeTitle)
							.matchedGeometryEffect(id: "title", in: ns)

						RoundedRectangle(cornerRadius: 12)
							.fill(Color.green)
							.frame(height: 200)
							.overlay(Text("Main Content B").foregroundColor(.white))
							.matchedGeometryEffect(id: "content", in: ns)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.35)) {
									showSecondScreen = false
								}
							}
					}
					.transition(.blurReplace)
				}
			}
			.animation(.easeInOut(duration: 0.35), value: showSecondScreen)
			.navigationTitle("") // Empty because we use custom toolbar
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					if showSecondScreen {
						Button {
							withAnimation(.easeInOut(duration: 0.35)) {
								showSecondScreen = false
							}
						} label: {
							AvatarStackView(circleSize: 42, shouldCutout: false)
						}
						.padding(.horizontal, -8)
						.matchedGeometryEffect(id: "toolbar", in: ns)
					}
				}

				ToolbarItem(placement: .topBarLeading) {
					if !showSecondScreen {
						Button {
							withAnimation(.easeInOut(duration: 0.35)) {
								showSecondScreen = true
							}
						} label: {
							Label("Next", systemImage: "star")
						}
						.matchedGeometryEffect(id: "toolbar", in: ns)
					}
				}
			}
		}
	}
}

#Preview {
	ToolbarContentTransitionDemo()
}
