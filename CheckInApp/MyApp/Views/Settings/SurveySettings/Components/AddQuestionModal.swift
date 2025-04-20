//
//  AddQuestionModal.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-12.
//

import SwiftUI

struct AddQuestionModal: View {
    @Environment(\.dismiss) var dismiss
    @Binding var questions: [SurveyQuestion]

    @State private var questionText = ""
    @State private var includeCheckmark = true
    @State private var includeTextField = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Question")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Write question here...", text: $questionText)
                .padding()
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Toggle("Has Checkmark", isOn: $includeCheckmark)
            Toggle("Has Textfield", isOn: $includeTextField)

            Button("Add Question") {
                guard !questionText.isEmpty else { return }
                let newQuestion = SurveyQuestion(
                    text: questionText,
                    hasCheckmark: includeCheckmark,
                    hasTextField: includeTextField
                )
                questions.append(newQuestion)
                dismiss()
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button("Cancel") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationBackground(.thinMaterial)
    }
}

#Preview {
    AddQuestionModal(questions: .constant([]))
}
