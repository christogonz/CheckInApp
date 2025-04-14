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

    init(viewModel: CustomSurveyViewModel, survey: SurveyForm) {
        self.viewModel = viewModel
        self.survey = survey
        _title = State(initialValue: survey.title)
        _questions = State(initialValue: survey.questions)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Botones arriba
            HStack(spacing: 16) {
                Button(action: {
                    showAddModal = true
                }) {
                    Label("Add Question", systemImage: "plus")
                        .padding(8)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Spacer()

                Button(action: {
                    viewModel.updateSurvey(
                        original: survey,
                        updated: SurveyForm(id: survey.id, title: title, questions: questions)
                    )
                    dismiss()
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title2)
                }

                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            // Campo de título
            TextField("Survey Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

            Text("All Questions")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(questions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Text", text: $questions[index].text)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            Toggle("Has Checkmark?", isOn: $questions[index].hasCheckmark)
                            Toggle("Has Textfield?", isOn: $questions[index].hasTextField)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .onDelete { indexSet in
                        questions.remove(atOffsets: indexSet)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.background)
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
    dummyViewModel.addSurvey(exampleSurvey)

    return EditSurveyFormView(viewModel: dummyViewModel, survey: exampleSurvey)
}
