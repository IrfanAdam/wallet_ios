import SwiftUI

struct ContactCard: View {
	let name: String
	let maskedID: String
	let number: String
	let imageURL: String

	var body: some View {
		HStack(spacing: 12) {

			// Profile Image
			AsyncImage(url: URL(string: imageURL)) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.frame(width: 48, height: 48)

				case .success(let img):
					img
						.resizable()
						.scaledToFill()
						.frame(width: 48, height: 48)
						.clipShape(Circle())

				case .failure:
					Image(systemName: "person.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 48, height: 48)
						.foregroundColor(.gray)

				@unknown default:
					EmptyView()
				}
			}

			VStack(alignment: .leading, spacing: 4) {

				// Name + Masked ID Row
				HStack {
					Text(name)
						.font(.system(size: 17, weight: .semibold))
						.foregroundColor(.primary)
						.lineLimit(1)

					Spacer()

					Text(maskedID)
						.font(.system(size: 15))
						.foregroundColor(.secondary)
						.lineLimit(1)
				}

				// Number below
				Text(number)
					.font(.system(size: 15))
					.foregroundColor(.secondary)
			}
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 12)
	}
}

#Preview {
	ContactCard(
		name: "Oluwaseun Oluwatoyin Ad...",
		maskedID: "we******qe",
		number: "7127128312912",
		imageURL: "https://source.unsplash.com/random/200x200?face,portrait"
	)
	.preferredColorScheme(.light)
}
