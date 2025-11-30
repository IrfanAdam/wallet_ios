import SwiftUI

struct AnalyticsSheet: View {
    var body: some View {
        ScrollView { // Makes it scrollable if content is larger than the sheet
            VStack(alignment: .leading, spacing: 16) {
                Text("Detailed Breakdown")
                    .font(.title.bold())

                SpendingSheetView()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading) // aligns to top left
            .padding(0)
            
            VStack(spacing: 20) { ForEach(1...10, id: \.self) { i in Text("Item \(i)") .frame(maxWidth: .infinity) .cornerRadius(8) } }
        }
        .presentationDetents([.height(420), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    AnalyticsSheet()
}
