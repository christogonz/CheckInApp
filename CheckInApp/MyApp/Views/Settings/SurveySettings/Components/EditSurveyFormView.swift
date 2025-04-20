//
//  EditSurveyFormView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//


import SwiftUI

struct EditSurveyFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CustomSurveyViewModel

    let survey: SurveyForm
    @State private var title: String
    @State private var questions: [SurveyQuestion]
    @State private var showDeleteAlert = false
    @State private var showAddModal = false

    init(survey: SurveyForm, viewModel: CustomSurveyViewModel) {
        self.survey = survey
        self._title = State(initialValue: survey.title)
        self._questions = State(initialValue: survey.questions)
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Edit Survey title")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        TextField("Survey Title", text: $title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text("All Questions")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 12) {
                            ForEach(Array(questions.enumerated()), id: \.element.id) { index, _ in
                                QuestionEditorView(question: $questions[index])
                            }
                            .onDelete { indexSet in
                                questions.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    .padding()
                }

                Divider()

                HStack(spacing: 12) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        showAddModal = true
                    }) {
                        Label("Add Question", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button(action: {
                        let updated = SurveyForm(id: survey.id, title: title, questions: questions)
                        viewModel.updateSurvey(original: survey, updated: updated)
                        dismiss()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                            .frame(width: 100, height: 55)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .background(Color.background)
            .navigationTitle("Edit Survey")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddModal) {
                AddQuestionModal(questions: $questions)
            }
            .alert("Are you sure you want to delete this survey?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteSurvey(by: survey)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)

                    }
                }
            }
        }
    }
}

struct QuestionEditorView: View {
    @Binding var question: SurveyQuestion

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Text", text: $question.text)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Toggle("Has Checkmark?", isOn: $question.hasCheckmark)
            Toggle("Has Textfield?", isOn: $question.hasTextField)
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let exampleSurvey = SurveyForm(
        title: "Demo in store?",
        questions: [
            SurveyQuestion(text: "Pixel 9a", hasCheckmark: true, hasTextField: true),
            SurveyQuestion(text: "Pixel 9 Pro", hasCheckmark: true, hasTextField: false)
        ]
    )

    let dummyViewModel = CustomSurveyViewModel()
    return EditSurveyFormView(survey: exampleSurvey, viewModel: dummyViewModel)
}
