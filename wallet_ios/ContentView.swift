import SwiftUI

struct AppView: View {

    @State private var showDetails = false

    var body: some View {
        NavigationStack {
            VStack() {
                // Your widget placed inside the screen
                DataWidget().frame(maxWidth: 200, maxHeight: 220)
                .onTapGesture {
                    showDetails = true   // Trigger sheet on tap
                }.sheet(isPresented: $showDetails) {
                    AnalyticsSheet()
                }
            }
            .navigationTitle("Native Toolbar") // Native toolbar title
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image("ph_credit-card-bold")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                    }
                }
            }
        }
    }
}

#Preview {
    AppView()
}

