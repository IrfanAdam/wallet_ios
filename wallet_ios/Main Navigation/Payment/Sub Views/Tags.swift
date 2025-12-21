import SwiftUI
import Foundation

enum PaymentTag: String, CaseIterable, Identifiable {
	case remittance = "Remittance"
	case festivals = "Festivals"
	case groceries = "Groceries"
	case other = "Other"
	
	var id: String { rawValue }
}

struct PaymentTagSection: View {
	@Binding var note: String
	@Binding var selectedTags: [PaymentTag]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			
			// Purpose / note field
			HStack {
				TextField("For Festivals", text: $note)
					.textInputAutocapitalization(.sentences)
				
				Image(systemName: "pencil")
					.foregroundStyle(.secondary)
			}
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 16)
					.strokeBorder(.secondary.opacity(0.3))
			)
			
			// Tags stack
			SimpleFlowWrap(
				items: PaymentTag.allCases.map { tag in
					AnyView(
						TagChip(
							title: tag.rawValue,
							isSelected: selectedTags.contains(tag)
						) {
							toggle(tag)
						}
					)
				}
			)
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	
	private func toggle(_ tag: PaymentTag) {
		if selectedTags.contains(tag) {
			selectedTags.removeAll { $0 == tag }
		} else {
			selectedTags.append(tag)
		}
	}
}
