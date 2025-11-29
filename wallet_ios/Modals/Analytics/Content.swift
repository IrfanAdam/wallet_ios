import SwiftUI
import Charts

struct SpendingData: Identifiable {
    let id = UUID()
    let month: String
    let spent: Double
    let received: Double
}

struct SpendingSheetView: View {
    @State private var data: [SpendingData] = [
        .init(month: "Apr", spent: 1200, received: 300),
        .init(month: "May", spent: 900, received: 400),
        .init(month: "Jun", spent: 800, received: 600),
        .init(month: "Jul", spent: 1100, received: 500),
        .init(month: "Aug", spent: 1200, received: 200),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Spendings")
                .font(.title2)
                .bold()
            
            // Chart
            Chart {
                ForEach(data) { entry in
                    BarMark(
                        x: .value("Month", entry.month),
                        y: .value("Spent", entry.spent)
                    )
                    .foregroundStyle(Color.blue)
                    
                    BarMark(
                        x: .value("Month", entry.month),
                        y: .value("Received", entry.received)
                    )
                    .foregroundStyle(Color.green)
                }
            }
            .chartLegend(position: .bottom)
            .frame(height: 220)
            .padding(.horizontal)
            
            // Selected month summary
            VStack(spacing: 8) {
                HStack {
                    Text("August 2025")
                        .font(.headline)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("- CFA 1200")
                            .foregroundColor(.blue)
                        Text("+ CFA 200")
                            .foregroundColor(.green)
                    }
                }
                
                Text("By adding additional CFA 800 this month you’re more likely to meet your set target in time")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Button("I trust myself") { }
                        .buttonStyle(.bordered)
                    Button("Explore Loans") { }
                        .buttonStyle(.borderedProminent)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
            VStack(spacing: 20) {
                ForEach(1...50, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    SpendingSheetView()
}
