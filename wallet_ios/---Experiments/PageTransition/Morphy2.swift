import SwiftUI

struct MorphNavDemo: View {
	@Namespace private var ns

	var body: some View {
		NavigationStack {
			List{
				ForEach(["A", "B", "C"], id: \.self) { item in
					NavigationLink(value: item) {
						HStack(spacing: 16) {
							RoundedRectangle(cornerRadius: 12)
								.fill(.blue)
								.frame(width: 40, height: 40)
								.matchedTransitionSource(id: item, in: ns)
							Text("Item \(item)")
								.foregroundStyle(.primary)
						}
					}
				}
			}
			.navigationTitle("List")
			.navigationDestination(for: String.self) { item in
				MorphNavDetail(namespace: ns, item: item)
					.navigationTransition(.zoom(sourceID: item, in: ns))
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
					} label: {
						Text("Back")
					}
				}
			}
		}
	}
}

struct MorphNavDetail: View {
	var namespace: Namespace.ID
	let item: String
	@Environment(\.dismiss) private var dismiss


	var body: some View {
		VStack {
			HStack(spacing: 12) {
				Spacer()
			}
			.padding()
			.background(.ultraThinMaterial)


			Text("Content for item \(item)")
				.font(.title)

			Spacer()
		}
		.navigationTitle("Item \(item)")
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				HStack(spacing: -8) {   // <-- negative spacing works here

					Button {
						dismiss()
					} label: {
						Capsule()
							.fill(.blue)
							.frame(width: 36, height: 36)
							.overlay(
								Image(systemName: "chevron.left")
									.foregroundStyle(.white)
									.font(.system(size: 16, weight: .semibold))
							)
					}
					.buttonStyle(.borderless)

					Button {
						dismiss()
					} label: {
						Capsule()
							.fill(.white)
							.frame(width: 36, height: 36)
							.overlay(
								Image(systemName: "chevron.up")
									.foregroundStyle(.black)
									.font(.system(size: 16, weight: .semibold))
							)
					}
					.buttonStyle(.plain)
				}
			}
		}
	}
}

#Preview {
	MorphNavDemo()
}
