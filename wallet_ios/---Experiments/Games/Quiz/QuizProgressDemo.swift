import SwiftUI

// MARK: - Model

struct QuizQuestion: Identifiable {
	let id = UUID()
	let title: String
	let options: [String]
	var selectedIndex: Int? = nil
}

// MARK: - Main Demo View

struct QuizDemoView: View {
	
	@State private var questions: [QuizQuestion] = [
		QuizQuestion(title: "What is 2 + 2?", options: ["3", "4", "5", "6"]),
		QuizQuestion(title: "Capital of France?", options: ["Berlin", "Paris", "Rome", "Madrid"]),
		QuizQuestion(title: "SwiftUI is by?", options: ["Google", "Apple", "Meta", "Microsoft"])
	]
	
	@State private var currentIndex = 0
	
	private var progress: Double {
		Double(currentIndex) / Double(questions.count)
	}
	
	var body: some View {
		VStack(spacing: 20) {
			
			// Top Progress
			VStack(alignment: .leading, spacing: 8) {
				Text("\(Int(progress * 100))% complete")
					.font(.headline)
				
				ProgressView(value: progress)
					.progressViewStyle(.linear)
					.tint(.blue)
					.animation(.easeInOut, value: progress)
			}
			
			Spacer()
			
			if currentIndex < questions.count {
				QuestionCard(question: $questions[currentIndex]) {
					goToNext()
				}
			} else {
				Text("Quiz Complete 🎉")
					.font(.title2)
					.bold()
			}
			
			Spacer()
		}
		.padding()
		.frame(height: 360, alignment: .top)
	}
	
	private func goToNext() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			withAnimation {
				currentIndex += 1
			}
		}
	}
}

// MARK: - Question Card

struct QuestionCard: View {
	
	@Binding var question: QuizQuestion
	var onAnswered: () -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			
			Text(question.title)
				.font(.headline)
			
			ForEach(question.options.indices, id: \.self) { index in
				Button {
					guard question.selectedIndex == nil else { return }
					
					question.selectedIndex = index
					onAnswered()
					
				} label: {
					Text(question.options[index])
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.gray.opacity(0.1))
						.cornerRadius(10)
				}
			}
		}
	}
}

#Preview("Quiz Demo") {
	QuizDemoView()
}
