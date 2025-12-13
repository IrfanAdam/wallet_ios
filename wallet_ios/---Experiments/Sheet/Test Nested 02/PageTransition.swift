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
		VStack(alignment: .center, spacing: 0) {
			Spacer()
			
			NavigationLink {
				SecondPage(namespace: ns)
					.navigationTransition(.zoom(sourceID: "button", in: ns))
			} label: {
				HStack(alignment: .center, spacing: 0) {
					Text("Go to Details")
				}
				.frame(width: 200, height: 50)
				.padding()
				.background(.blue)
				.foregroundStyle(.white)
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.matchedTransitionSource(id: "button", in: ns)
			}
			.buttonStyle(.plain)
			.padding()
			
			Spacer()
		}.navigationTitle("Page One")
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button {
					
				} label: {
					Image(systemName: "chevron.left")
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

struct SecondPage: View {
	let namespace: Namespace.ID
	@State private var collapsed = false
	@Environment(\.dismiss) private var dismiss
	
	// Define spring animation parameters once
	private let spring = Animation.spring(response: 0.42, dampingFraction: 0.85)
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				// Optimized background: use material for more Apple-native feel
				Color(collapsed ? UIColor.systemBackground : UIColor.systemBlue)
					.ignoresSafeArea()
					.animation(spring, value: collapsed)
				
				// Collapsing rectangle
				RoundedRectangle(cornerRadius: collapsed ? 16 : 0)
					.fill(.blue)
					.frame(
						width: collapsed ? 240 : geo.size.width,
						height: collapsed ? 320 : geo.size.height
					)
					.animation(spring, value: collapsed)
			}
			.onAppear {
				// Animate after navigation completes
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
					withAnimation(spring) {
						collapsed = true
					}
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.navigationTitle("Page Two")
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button {
					// Phase 1: restore rectangle and background
					withAnimation(spring) {
						collapsed = false
					}
					
					// Phase 2: dismiss after the animation finishes
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
						dismiss()
					}
				} label: {
					Image(systemName: "chevron.left")
				}
			}
		}
	}
}

#Preview {
	SeamlessPageNavDemo()
}
