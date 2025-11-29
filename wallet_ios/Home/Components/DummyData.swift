import SwiftUI

struct StockLikeBackgroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.width
        let h = rect.height

        // Start left side
        path.move(to: CGPoint(x: 0.0 * w, y: 0.70 * h))

        // Early small rise
        path.addQuadCurve(
            to: CGPoint(x: 0.20 * w, y: 0.40 * h),
            control: CGPoint(x: 0.10 * w, y: 0.55 * h)
        )

        // Dip
        path.addQuadCurve(
            to: CGPoint(x: 0.40 * w, y: 0.65 * h),
            control: CGPoint(x: 0.30 * w, y: 0.20 * h)
        )

        // Strong rise
        path.addQuadCurve(
            to: CGPoint(x: 0.65 * w, y: 0.25 * h),
            control: CGPoint(x: 0.50 * w, y: 0.75 * h)
        )

        // Final sharp push upward (stock-like spike)
        path.addQuadCurve(
            to: CGPoint(x: 1.0 * w, y: 0.45 * h),
            control: CGPoint(x: 0.85 * w, y: 0.10 * h)
        )

        // Close bottom area
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()

        return path
    }
}

#Preview {
    StockLikeBackgroundShape()
        .fill(.blue.opacity(0.3))
        .frame(width: 300, height: 200)
}

