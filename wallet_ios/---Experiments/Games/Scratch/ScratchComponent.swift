import SwiftUI

/// A card that hides `content` behind a scratchable silver surface.
///
/// When the scratch threshold is crossed, a radial wipe animation expands
/// from the centroid of all scratches, morphing the remaining silver away
/// before the layer is removed.
public struct ScratchRevealCard<Content: View>: View {
	
	private let content: Content
	private let revealThreshold: CGFloat
	
	@StateObject private var viewModel: ScratchViewModel
	
	/// Whether the scratch layer is present in the hierarchy.
	@State private var showScratchLayer = true
	
	/// Live reference to the UIKit canvas — set once on first makeUIView.
	@State private var canvas: ScratchCanvas?

	@State private var appearTilt: Double = 8

	public init(
		revealThreshold: CGFloat = 0.50,
		@ViewBuilder content: () -> Content
	) {
		self.content = content()
		self.revealThreshold = revealThreshold
		_viewModel = StateObject(wrappedValue: ScratchViewModel(revealThreshold: revealThreshold))
	}
	
	public var body: some View {
		GeometryReader { geo in
			ZStack {
				cardBackground
					.overlay(content)
				
				if showScratchLayer {
					ScratchLayerView(viewModel: viewModel) { liveCanvas in
						canvas = liveCanvas
					}
					.clipShape(RoundedRectangle(cornerRadius: 20))
				}
			}
			.onChange(of: geo.size) {_, newSize in
				viewModel.canvasSize = newSize
			}
			.onAppear {
				viewModel.canvasSize = geo.size

				appearTilt = 14

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
					appearTilt = -4   // reverse tilt

					DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
						appearTilt = 0   // settle
					}
				}
			}
			// Watch for threshold crossing and drive the reveal animation.
			.onChange(of: viewModel.isFullyRevealed) {_, revealed in
				guard revealed, let canvas else {
					// Canvas not ready yet — fall back to instant removal.
					showScratchLayer = false
					return
				}
				let centroid = viewModel.scratchCentroid
				canvas.playRevealAnimation(centroid: centroid) {
					// Fires after the CAAnimation completes — safe to remove the view.
					showScratchLayer = false
				}
			}
		}
		.rotation3DEffect(
			.degrees(appearTilt),
			axis: (x: 1, y: -0.6, z: 0),
			perspective: 0.9
		)
		.animation(.spring(response: 1.0, dampingFraction: 0.78, blendDuration: 0), value: appearTilt)
	}
	
	private var cardBackground: some View {
		RoundedRectangle(cornerRadius: 20)
			.fill(Color.white)
			.shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
	}
}
