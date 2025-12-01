import SwiftUI

struct SpendingData: Identifiable {
    let id = UUID()
    let month: String
    let spent: Double
    let received: Double
    let isGhost: Bool    // For faded future months
    
    init(month: String, spent: Double, received: Double, isGhost: Bool = false) {
            self.month = month
            self.spent = spent
            self.received = received
            self.isGhost = isGhost
        }
}

struct SpendingChartStyle {
    var barWidth: CGFloat = 16
    var barSpacing: CGFloat = 0
    var chartHeight: CGFloat = 240
    var cornerRadius: CGFloat = 6
    var highlightPadding: CGFloat = 4
    var highlightBorder: CGFloat = 3.2
    var opacityGhost: CGFloat = 0.25
    var verticalGap: CGFloat = 1.5
}

struct SpendingSheetView: View {
    @State private var selectedIndex: Int = 7   // August selected
    
    private var data: [SpendingData] = [
        .init(month: "JAN", spent: 24, received: 120),
        .init(month: "FEB", spent: 80, received: 32),
        .init(month: "MAR", spent: 100, received: 42),
        .init(month: "APR", spent: 200, received: 50),
        .init(month: "MAY", spent: 120, received: 90),
        .init(month: "JUN", spent: 80,  received: 60),
        .init(month: "JUL", spent: 150, received: 70),
        .init(month: "AUG", spent: 180, received: 100),
        .init(month: "SEP", spent: 90,  received: 20, isGhost: true),
        .init(month: "OCT", spent: 70,  received: 10, isGhost: true),
        .init(month: "NOV", spent: 40,  received: 10, isGhost: true)
    ]
    
    // Shared editable chart values
    let style = SpendingChartStyle()
    
    private var maxValue: Double {
            data.map { $0.spent + $0.received }.max() ?? 1
        }
        
        var body: some View {
            VStack(spacing: 16) {
                chart
                details
            }
            .padding(0)
        }
        
        private var chart: some View {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: style.barSpacing) {
                        ForEach(Array(data.enumerated()), id: \.1.id) { index, entry in
                            content(for: entry, index: index)
                                .id(index)   // ← IMPORTANT
                        }
                    }
                }
                .onAppear {
                    // Jump to the last item
                    if let lastIndex = data.indices.last {
                        proxy.scrollTo(lastIndex, anchor: .trailing)
                    }
                }
            }
            .frame(height: style.chartHeight + 50)
            
        }
    
        @ViewBuilder
        private func content(for entry: SpendingData, index: Int) -> some View {
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 2) {
                    VStack(spacing: style.verticalGap) {
                        Color.green
                            .opacity(entry.isGhost ? style.opacityGhost : 1.0)
                            .frame(height: CGFloat(entry.received / maxValue) * style.chartHeight * 0.75)
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                    .frame(width: style.barWidth)

                    VStack(spacing: style.verticalGap) {
                        Color.blue
                            .opacity(entry.isGhost ? style.opacityGhost : 1.0)
                            .frame(height: CGFloat(entry.received / maxValue) * style.chartHeight * 0.75)
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                        Color.blue
                            .opacity(entry.isGhost ? style.opacityGhost : 1.0)
                            .frame(height: CGFloat(entry.spent / maxValue) * style.chartHeight * 0.75)
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                    .frame(width: style.barWidth)
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(index == selectedIndex ? Color.black.opacity(1) : Color.clear,
                                lineWidth: style.highlightBorder)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))

                Text(entry.month)
                    .font(.caption)
                    .foregroundColor(.black.opacity(entry.isGhost ? 0.3 : 0.8))
            }
        }

        
        private var details: some View {
            VStack(spacing: 12) {
                Text("Details Section Placeholder")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Divider()
            }
        }
}

#Preview {
    SpendingSheetView()
}
