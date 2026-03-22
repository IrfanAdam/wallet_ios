import SwiftUI

struct TitleDropdownView: View {
	@State private var selected = "Upcoming"
	@State private var showMenu = false
	
	let options = ["Upcoming", "Past", "All"]
	
	var body: some View {
		NavigationStack {
			Text("Selected: \(selected)")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color(.systemGroupedBackground))
				.toolbar {
					
					ToolbarItem(placement: .topBarLeading) {
						Button {
							withAnimation(.easeInOut(duration: 0.2)) {
								showMenu.toggle()
							}
						} label: {
							HStack(spacing: 4) {
								Text(selected)
									.font(.title)
									.fontWeight(.bold)
								
								Image(systemName: "chevron.down")
									.rotationEffect(.degrees(showMenu ? 180 : 0))
									.animation(.easeInOut(duration: 0.2), value: showMenu)
									.foregroundColor(.gray)
							}
							.background(.clear)
							.contentShape(Rectangle())
						}
						.popover(isPresented: $showMenu) {
							VStack(alignment: .leading, spacing: 12) {
								ForEach(options, id: \.self) { option in
									Button {
										selected = option
										showMenu = false
									} label: {
										HStack(spacing: 4) {
											Image(systemName: "chevron.down")
												.rotationEffect(.degrees(showMenu ? 180 : 0))
												.animation(.easeInOut(duration: 0.2), value: showMenu)
												.foregroundColor(.gray)
											
											Text(option)
												.font(.title3)
												.fontWeight(.bold)
												.foregroundStyle(Color.black)
											
										}
										.padding(8)
									}
								}
								.background(Color.clear)
							}
							.frame(width: 180, alignment: .leading)
							.padding()
							.presentationCompactAdaptation(.popover)
							.presentationBackground(Color.clear)
						}
					}
					.sharedBackgroundVisibility(.hidden)
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 20, weight: .bold))
					}
				}
		}
	}
}

#Preview {
	TitleDropdownView()
}
