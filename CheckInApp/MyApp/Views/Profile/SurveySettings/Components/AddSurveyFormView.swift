//
//  AddSurveyFormView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import SwiftUI

struct AddSurveyFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CustomSurveyViewModel

    @State private var title = ""
    @State private var questions: [SurveyQuestion] = []
    @State private var questionText = ""
    @State private var includeCheckmark = true
    @State private var includeTextField = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("New Survey")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)

            VStack(spacing: 12) {
                TextField("Demo in Store...?", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Divider()

                Text("Add question")
                    .font(.headline)

                TextField("Write your question here...", text: $questionText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Toggle("Has Checkmark?", isOn: $includeCheckmark)
                Toggle("Has TextField?", isOn: $includeTextField)

                Button("Add Question") {
                    guard !questionText.isEmpty else { return }
                    let newQuestion = SurveyQuestion(
                        text: questionText,
                        hasCheckmark: includeCheckmark,
                        hasTextField: includeTextField
                    )
                    questions.append(newQuestion)
                    questionText = ""
                    includeCheckmark = true
                    includeTextField = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Divider()

            Text(" All Questions")
                .font(.headline)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(questions) { question in
                        
                            VStack(alignment: .leading, spacing: 4) {
                                Text(question.text)
                                    .font(.subheadline)
                                HStack {
                                    if question.hasCheckmark { Text("✅") }
                                    if question.hasTextField { Text("🔢") }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                    .onDelete { indexSet in
                        questions.remove(atOffsets: indexSet)
                    }
                }
            }


            Spacer()

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button("Add Survey") {
                    guard !title.isEmpty, !questions.isEmpty else { return }
                    let survey = SurveyForm(title: title, questions: questions)
                    viewModel.addSurvey(survey)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color.background)
    }
}

#Preview {
    AddSurveyFormView(viewModel: CustomSurveyViewModel())
}
