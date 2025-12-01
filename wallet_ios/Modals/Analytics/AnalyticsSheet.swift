import SwiftUI

struct AnalyticsSheet: View {
	
	  @Environment(\.dismiss) private var dismiss 
  
    @State private var selectedTab: Period = .monthly

    enum Period: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    
    var body: some View {
      NavigationStack {
				ScrollView {
					LazyVStack(pinnedViews: [.sectionHeaders]) {
						Section {
							SpendingSheetView()
							VStack(spacing: 20) { ForEach(1...10, id: \.self) { i in Text("Item \(i)") .frame(maxWidth: .infinity) .cornerRadius(8) } }
						} header: {
							Picker("", selection: $selectedTab) {
								ForEach(Period.allCases, id: \.self) { tab in
									Text(tab.rawValue)
								}
							}
							.pickerStyle(.segmented)
							.padding(0)
							.background(
								RoundedRectangle(cornerRadius: 12, style: .continuous)
									.fill(Color(.systemGray6).opacity(0.3)) // subtle background color
							)
							.overlay(
								RoundedRectangle(cornerRadius: 12, style: .continuous)
									.stroke(Color.gray.opacity(0.3), lineWidth: 1) // optional border
							)
							.shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1) // subtle shadow
							.padding(.horizontal)
						}
					}
				}
				.navigationTitle("Detailed Breakdown")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							dismiss()   // <-- dismiss the sheet
						} label: {
							Image(systemName: "xmark")
								.font(.body.weight(.semibold))
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button { /* info */ } label: {
							Image(systemName: "exclamationmark.circle")
								.font(.body.weight(.semibold))
						}
					}
				}
				.presentationDetents([.height(360), .medium, .large])
				.presentationDragIndicator(.visible)
			}
			.background(Color(red: 0.98, green: 0.97, blue: 0.96))
    }
}

#Preview {
    AnalyticsSheet()
}
