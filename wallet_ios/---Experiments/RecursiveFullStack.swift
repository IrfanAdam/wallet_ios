import SwiftUI

struct PageSheetDemo: View {
    @State private var showLevel2 = false

    var body: some View {
        Button("Open Level 2") {
            showLevel2 = true
        }
        .sheet(isPresented: $showLevel2) {
            Level2View()
                .presentationSizing(.page)
                .presentationDragIndicator(.visible)
        }
    }
}

struct Level2View: View {
    @State private var showLevel3 = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Level 2")
                .font(.title)

            Button("Open Level 3") {
                showLevel3 = true
            }
        }
        .padding()
        .sheet(isPresented: $showLevel3) {
            Level2View()
                .presentationSizing(.page)
                .presentationDragIndicator(.visible)
        }
    }
}

struct Level3View: View {
    @State private var showLevel4 = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Level 3")
                .font(.title)

            Button("Open Level 4") {
                showLevel4 = true
            }
        }
        .padding()
        .sheet(isPresented: $showLevel4) {
            Level4View()
                .presentationSizing(.page)
                .presentationDragIndicator(.visible)
        }
    }
}

struct Level4View: View {
    @State private var showLevel5 = false
    var body: some View {
        VStack(spacing: 20) {
            Text("Level 4")
                .font(.title)

            Button("Open Level 5") {
                showLevel5 = true
            }
        }
        .padding()
        .sheet(isPresented: $showLevel5) {    // ✅ FIX → attach sheet here
            Level5View()
                .presentationSizing(.page)
                .presentationDragIndicator(.visible)
        }

    }
}

struct Level5View: View {
    @State private var showResizableSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Level 5")
                .font(.title)

            Text("This is the 5th nested page sheet.")

            Button("Open Resizable Sheet") {
                showResizableSheet = true
            }
            .padding(.top, 30)
        }
        .padding()
        .sheet(isPresented: $showResizableSheet) {
            ResizableInnerSheet()
                .presentationDetents([.height(320), .medium, .large])  // small–medium–large
                .presentationDragIndicator(.visible)
        }
    }
}

struct ResizableInnerSheet: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Resizable Sheet")
                    .font(.title2)

                ForEach(1...20, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    PageSheetDemo()
}
