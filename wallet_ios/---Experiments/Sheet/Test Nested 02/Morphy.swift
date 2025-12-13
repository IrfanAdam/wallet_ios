import SwiftUI

struct NavMorphRoot: View {
	@Namespace private var ns // The single namespace shared across the entire NavigationStack hierarchy
	@State private var selected: String? = nil

	var body: some View {
		NavigationStack {
			NavMorphList(namespace: ns, selected: $selected)
				.navigationDestination(item: $selected) { item in
					NavMorphDetail(namespace: ns, item: item)
						.navigationTransition(.zoom(sourceID: item, in: ns))
				}
		}
	}
}

struct NavMorphList: View {
	var namespace: Namespace.ID
	@Binding var selected: String?

	let items = ["A", "B", "C"]

	var body: some View {
		List(items, id: \.self) { item in
			RoundedRectangle(cornerRadius: 24)
				.fill(.blue.opacity(0.4))
				.frame(height: 120)
				.overlay(Text("Card \(item)").font(.title))
				.matchedTransitionSource(id: item, in: namespace)
				.contentShape(Rectangle())
				.onTapGesture {
					selected = item
				}
		}
		.navigationTitle("Cards")
	}
}

struct NavMorphDetail: View {
	var namespace: Namespace.ID
	let item: String
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 40) {
			Spacer().frame(height: 30)

			Text("Card \(item)")
				.font(.largeTitle)

			Spacer()
		}
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				RoundedRectangle(cornerRadius: 14)
					.fill(.blue.opacity(0.4))
					.frame(width: 60, height: 36)
			}
			ToolbarItem(placement: .topBarTrailing) {
				Button("Back") { dismiss() }
			}
		}
	}
}

#Preview {
	NavMorphRoot()
}
