import SwiftUI

struct SendMoneyFlowRootView: View {
	@State private var navigationPath = NavigationPath()
	@State private var currentDetent: PresentationDetent = .medium
	// 1. Declare a namespace to link source and destination views
	@Namespace private var namespace

	var body: some View {
		NavigationStack(path: $navigationPath) {
			SearchSheet(navigationPath: $navigationPath, currentDetent: $currentDetent, namespace: namespace)
				.navigationDestination(for: String.self) { value in
					if value == "PaymentInitiation" {
						PaymentInitiationView(currentDetent: $currentDetent, namespace: namespace)
						// 3. Apply the zoom transition to the destination view
							.navigationTransition(.zoom(sourceID: "action_button_source", in: namespace))
					}
				}
			// .transition(.blurReplace) removed, use .navigationTransition instead
		}
		.presentationDetents([.medium, .large, .height(240)], selection: $currentDetent)
		.presentationContentInteraction(.scrolls)
		.presentationDragIndicator(.visible)
		.presentationBackground(.regularMaterial)
		// Smooth animation for detent changes
		.animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentDetent)
	}
}

// MARK: - Search Sheet
struct SearchSheet: View {
	@Binding var navigationPath: NavigationPath
	@Binding var currentDetent: PresentationDetent
	@Environment(\.dismiss) var dismiss
	@State private var searchText = ""
	var namespace: Namespace.ID // Accept the namespace

	var body: some View {
		VStack(spacing: 0) {
			searchHeader

			ScrollView {
				LazyVStack(spacing: 12) {
					ForEach(0..<15) { i in
						resultRow(index: i)
					}
				}
				.padding(.horizontal)
				.padding(.top, 8)
			}

			actionButton
		}
		.navigationTitle("Send Money To")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") {
					dismiss()
				}
			}
		}
	}

	// ... searchHeader and resultRow remain the same ...
	private var searchHeader: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundColor(.secondary)
			TextField("Search contacts", text: $searchText)
				.textFieldStyle(.plain)
			if !searchText.isEmpty {
				Button(action: { searchText = "" }) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.secondary)
				}
			}
		}
		.padding(12)
		.background(Color(.systemGray6))
		.cornerRadius(10)
		.padding()
	}

	private func resultRow(index: Int) -> some View {
		Button(action: {}) {
			HStack(spacing: 12) {
				Circle()
					.fill(Color.blue.opacity(0.2))
					.frame(width: 44, height: 44)
					.overlay(
						Text("\(index)")
							.font(.headline)
							.foregroundColor(.blue)
					)

				VStack(alignment: .leading, spacing: 4) {
					Text("Contact \(index)")
						.font(.body)
						.foregroundColor(.primary)
					Text("user\(index)@example.com")
						.font(.caption)
						.foregroundColor(.secondary)
				}

				Spacer()

				Image(systemName: "chevron.right")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			.padding(12)
			.background(Color(.systemBackground))
			.cornerRadius(12)
			.shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
		}
		.buttonStyle(.plain)
	}


	private var actionButton: some View {
		Button {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
				currentDetent = .large
			}
			// Slight delay for smoother transition
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				navigationPath.append("PaymentInitiation")
			}
		} label: {
			HStack {
				Image(systemName: "arrow.right.circle.fill")
				Text("Continue to Payment")
			}
			.font(.headline)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity)
			.padding()
			.background(Color.blue)
			.cornerRadius(12)
		}
		.padding()
		.background(Color(.systemBackground))
		.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
		// 2. Mark this view as the source of the transition
		.matchedTransitionSource(id: "action_button_source", in: namespace)
	}
}

// MARK: - Payment Initiation View
struct PaymentInitiationView: View {
	@Binding var currentDetent: PresentationDetent
	var namespace: Namespace.ID // Accept the namespace
	@Environment(\.dismiss) var dismiss
	@State private var amount = ""
	@State private var note = ""
	@FocusState private var amountFieldFocused: Bool

	var body: some View {
		VStack(spacing: 16) {
			// Recipient info card
			recipientCard

			// Amount input
			amountSection

			// Note input
			noteSection

			// Action buttons
			actionButtons
		}
		.padding()
		.navigationTitle("Initiate Payment")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			// Ensure we're at large detent
			withAnimation {
				currentDetent = .large
			}
		}
	}

	// ... recipientCard, amountSection, noteSection remain the same ...

	private var recipientCard: some View {
		HStack(spacing: 12) {
			Circle()
				.fill(Color.green.opacity(0.2))
				.frame(width: 60, height: 60)
				.overlay(
					Image(systemName: "person.fill")
						.font(.title2)
						.foregroundColor(.green)
				)

			VStack(alignment: .leading, spacing: 4) {
				Text("John Doe")
					.font(.headline)
				Text("john.doe@example.com")
					.font(.subheadline)
					.foregroundColor(.secondary)
			}

			Spacer()
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
	}

	private var amountSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Amount")
				.font(.subheadline)
				.foregroundColor(.secondary)

			HStack {
				Text("$")
					.font(.title)
					.foregroundColor(.secondary)
				TextField("0.00", text: $amount)
					.font(.system(size: 36, weight: .bold))
					.keyboardType(.decimalPad)
					.focused($amountFieldFocused)
			}
			.padding()
			.background(Color(.systemGray6))
			.cornerRadius(12)
		}
	}

	private var noteSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Note (Optional)")
				.font(.subheadline)
				.foregroundColor(.secondary)

			TextField("What's this for?", text: $note)
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(12)
		}
	}

	private var actionButtons: some View {
		VStack(spacing: 12) {
			Button {
				// Handle payment confirmation
			} label: {
				Text("Send Payment")
					.font(.headline)
					.foregroundColor(.white)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.blue)
					.cornerRadius(12)
			}

			Button {
				withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
					currentDetent = .medium
				}
				dismiss()
			} label: {
				Text("Cancel")
					.font(.headline)
					.foregroundColor(.blue)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color(.systemGray6))
					.cornerRadius(12)
			}
		}
	}
}

// MARK: - Preview
#Preview {
	Color.clear
		.sheet(isPresented: .constant(true)) {
			SendMoneyFlowRootView()
		}
}
