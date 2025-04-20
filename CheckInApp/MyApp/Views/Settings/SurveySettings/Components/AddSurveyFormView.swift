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
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Title
                    Text("Survey Title")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("Demo in Store...?", text: $title)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // MARK: - Add Question
                    Text("Add a Question")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("Write your question here...", text: $questionText)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Toggle("Include Checkmark", isOn: $includeCheckmark)
                    Toggle("Include TextField", isOn: $includeTextField)

                    Button {
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
                    } label: {
                        Label("Add Question", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top)

                    Divider().padding(.vertical)

                    // MARK: - Preview Questions
                    if questions.isEmpty {
                        Text("Add Questions.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("All Questions")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 12) {
                            ForEach(questions) { question in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(question.text)
                                        .font(.subheadline)

                                    HStack(spacing: 8) {
                                        if question.hasCheckmark { Text("✅ Checkmark") }
                                        if question.hasTextField { Text("🔢 TextField") }
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .onDelete { indexSet in
                                questions.remove(atOffsets: indexSet)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.background)
            .navigationTitle("New Survey")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: - Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }

                // MARK: - Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !title.isEmpty, !questions.isEmpty else { return }
                        let survey = SurveyForm(title: title, questions: questions)
                        viewModel.addSurvey(survey)
                        dismiss()
                    }
                    .foregroundStyle(title.isEmpty || questions.isEmpty ? .gray : .accentColor)
                    .disabled(title.isEmpty || questions.isEmpty)
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    AddSurveyFormView(viewModel: CustomSurveyViewModel())
}
