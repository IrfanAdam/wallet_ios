import SwiftUI
import Combine
import AudioToolbox

/// Owns scratch state and determines when the reveal threshold is crossed.
///
/// ## Area estimation
/// We use a fixed-size grid of cells. A cell is marked "revealed" when a
/// scratch point's circle covers its centre. The fraction is
/// `revealedCells / totalCells`, clamped to [0, 1] so it can never exceed 1
/// even if points land outside the canvas bounds.
///
/// ## Thread safety
/// All methods must be called on the main actor (enforced by `@MainActor`).
/// `ScratchCanvas` calls `scratchDelegate` on the main thread, so this is
/// guaranteed as long as the coordinator doesn't dispatch elsewhere.
@MainActor
final class ScratchViewModel: ObservableObject {
	
	// MARK: - Published
	
	@Published private(set) var isFullyRevealed: Bool = false
	
	// MARK: - Configuration
	
	let revealThreshold: CGFloat   // 0 < threshold ≤ 1
	
	// MARK: - Internal — canvas size
	
	/// Set by `ScratchLayerView` once the canvas has laid out.
	/// Changing this resets the cell grid so estimates stay accurate.
	var canvasSize: CGSize = .zero {
		didSet {
			guard canvasSize != oldValue,
						canvasSize.width > 0, canvasSize.height > 0 else { return }
			// Recompute grid dimensions and rebuild revealed set from scratch history.
			rebuildGrid()
		}
	}
	
	// MARK: - Private
	
	private let gridSize: CGFloat = 12          // pt per cell — coarser = faster
	private var revealedCells = Set<Int>()
	private var gridCols: Int = 0
	private var gridRows: Int = 0
	private var totalCells: Int = 1             // never 0 to avoid division by zero
	
	/// Full history kept so the grid can be rebuilt if `canvasSize` changes.
	private var history: [ScratchPoint] = []
	
	/// Centre of mass of all scratched points — used as the animation origin.
	/// Falls back to the canvas centre if no scratches yet.
	var scratchCentroid: CGPoint {
		guard !history.isEmpty else {
			return CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
		}
		let sum = history.reduce(CGPoint.zero) {
			CGPoint(x: $0.x + $1.location.x, y: $0.y + $1.location.y)
		}
		return CGPoint(x: sum.x / CGFloat(history.count),
									 y: sum.y / CGFloat(history.count))
	}
	
	// MARK: - Init
	
	init(revealThreshold: CGFloat = 0.50) {
		self.revealThreshold = min(max(revealThreshold, 0.01), 1.0)
	}
	
	// MARK: - Public API
	
	func addScratch(_ scratch: ScratchPoint) {
		guard !isFullyRevealed, canvasSize.width > 0 else { return }
		history.append(scratch)
		markCells(for: scratch)
		checkThreshold()
	}
	
	func reset() {
		history = []
		revealedCells = []
		isFullyRevealed = false
	}
	
	// MARK: - Grid management
	
	private func rebuildGrid() {
		gridCols  = max(1, Int(ceil(canvasSize.width  / gridSize)))
		gridRows  = max(1, Int(ceil(canvasSize.height / gridSize)))
		totalCells = gridCols * gridRows
		
		// Re-mark all historical points under the new grid.
		revealedCells = []
		for point in history { markCells(for: point) }
		
		// Re-check threshold in case we already crossed it.
		checkThreshold()
	}
	
	// MARK: - Cell marking
	
	private func markCells(for scratch: ScratchPoint) {
		// Clamp the search window to valid grid bounds — this prevents
		// out-of-bounds keys and stops count from inflating past totalCells.
		let col = Int(scratch.location.x / gridSize)
		let row = Int(scratch.location.y / gridSize)
		let searchRadius = Int(ceil(scratch.radius / gridSize)) + 1
		
		let minCol = max(0, col - searchRadius)
		let maxCol = min(gridCols - 1, col + searchRadius)
		let minRow = max(0, row - searchRadius)
		let maxRow = min(gridRows - 1, row + searchRadius)
		
		// Early-exit if the scratch centre is entirely outside the canvas.
		guard maxCol >= minCol, maxRow >= minRow else { return }
		
		for r in minRow...maxRow {
			for c in minCol...maxCol {
				let centre = CGPoint(
					x: CGFloat(c) * gridSize + gridSize * 0.5,
					y: CGFloat(r) * gridSize + gridSize * 0.5
				)
				if scratch.contains(centre) {
					revealedCells.insert(r * gridCols + c)
				}
			}
		}
	}
	
	// MARK: - Threshold check
	
	private func checkThreshold() {
		guard !isFullyRevealed else { return }
		// Clamp fraction to 1.0 — revealed count can't logically exceed total,
		// but guard against floating-point edge cases just in case.
		let fraction = min(1.0, CGFloat(revealedCells.count) / CGFloat(totalCells))
		if fraction >= revealThreshold {
			withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
				isFullyRevealed = true
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
				AudioServicesPlaySystemSound(1158)
			}
		}
	}
}
