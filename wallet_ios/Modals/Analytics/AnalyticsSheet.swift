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
            .padding()
        }
        .presentationDetents([.height(420), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    AnalyticsSheet()
}
