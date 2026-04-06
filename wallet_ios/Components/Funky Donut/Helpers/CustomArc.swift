import SwiftUI

struct ArcSegment: View {
	@State private var start: CGFloat = 0.0
	@State private var end: CGFloat = 0.2
	
	var body: some View {
		VStack(spacing: 40) {
			
			Circle()
				.trim(from: start, to: end)
				.stroke(
					Color.blue,
					style: StrokeStyle(
						lineWidth: 16,
						lineCap: .round
					)
				)
				.rotationEffect(.degrees(-90))
				.frame(width: 200, height: 200)
				.animation(.easeInOut(duration: 0.6), value: start)
				.animation(.easeInOut(duration: 0.6), value: end)
			
			Button("Animate") {
				withAnimation(.easeInOut(duration: 0.6)) {
					start = CGFloat.random(in: 0...0.8)
					end = start + CGFloat.random(in: 0.1...0.3)
					
					// keep within bounds
					if end > 1 { end = 1 }
				}
			}
		}
	}
}

#Preview {
	ArcSegment()
}
