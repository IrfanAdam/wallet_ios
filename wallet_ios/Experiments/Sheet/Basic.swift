import SwiftUI

struct SheetTest: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show Sheet") {
            showSheet.toggle()
        }
        
        .sheet(isPresented: $showSheet) {
            BottomSheetView()
                .presentationDetents([.height(240), .medium, .large]) // Resizable between medium and large
                .presentationDragIndicator(.visible)
        }
    }
}

struct BottomSheetView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(1...50, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    SheetTest()
}
