import SwiftUI

/// Bridges `ScratchCanvas` (UIKit) into SwiftUI.
struct ScratchLayerView: UIViewRepresentable {
	
	@ObservedObject var viewModel: ScratchViewModel
	
	/// Called by `ScratchRevealCard` when it needs to trigger the reveal animation.
	/// The closure receives the live `ScratchCanvas` instance.
	var onCanvasReady: ((ScratchCanvas) -> Void)?
	
	func makeUIView(context: Context) -> ScratchCanvas {
		let canvas = ScratchCanvas()
		canvas.scratchDelegate = context.coordinator
		// Deliver the canvas reference on the next runloop tick so SwiftUI's
		// view update cycle has completed before the caller stores it.
		DispatchQueue.main.async { onCanvasReady?(canvas) }
		return canvas
	}
	
	func updateUIView(_ canvas: ScratchCanvas, context: Context) {
		if canvas.bounds.size != .zero {
			viewModel.canvasSize = canvas.bounds.size
		}
	}
	
	func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }
	
	final class Coordinator: NSObject, ScratchDelegate {
		private let viewModel: ScratchViewModel
		init(viewModel: ScratchViewModel) { self.viewModel = viewModel }
		
		func scratchCanvas(_ canvas: ScratchCanvas, didAdd scratch: ScratchPoint) {
			if viewModel.canvasSize == .zero {
				viewModel.canvasSize = canvas.bounds.size
			}
			viewModel.addScratch(scratch)
		}
	}
}
