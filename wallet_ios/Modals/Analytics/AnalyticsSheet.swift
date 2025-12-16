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
									ZStack {
										// Liquid background
										RoundedRectangle(cornerRadius: 14, style: .continuous)
											.fill(.ultraThinMaterial)        // or .thinMaterial
											.blur(radius: 0)                 // helps smooth edges
											.overlay(
												RoundedRectangle(cornerRadius: 14, style: .continuous)
													.stroke(Color.white.opacity(0.1)) // soft highlight border
											)
											.shadow(color: .black.opacity(0.1), radius: 6, y: 2)
										
										Picker("", selection: $selectedTab) {
											ForEach(Period.allCases, id: \.self) { tab in
												Text(tab.rawValue)
											}
										}
										.pickerStyle(.segmented)
										.padding(0) // spacing inside the glass
									}
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
                    Image(systemName: "exclamationmark")
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
