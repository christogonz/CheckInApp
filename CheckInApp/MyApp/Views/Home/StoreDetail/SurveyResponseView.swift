//
//  SurveyResponseView.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import SwiftUI

import SwiftUI

struct SurveyResponseView: View {
    let survey: SurveyForm
    let store: Store
    @ObservedObject var responseViewModel: SurveyResponseViewModel

    var body: some View {
        let storeResponse = responseViewModel.response(for: survey.id, storeID: store.id)

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Titel och beskrivning
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .foregroundStyle(Color.accentColor)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Survey: \(survey.title)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)
                    .foregroundStyle(Color.accentColor)

                // Frågor
                VStack(spacing: 16) {
                    ForEach(survey.questions) { question in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(question.text)
                                .font(.headline)
                            
                            Divider()

                            if question.hasCheckmark {
                                Toggle(isOn: Binding(
                                    get: { storeResponse.answers[question.id]?.checkmark ?? false },
                                    set: { newValue in
                                        let current = storeResponse.answers[question.id] ?? Answer()
                                        let updated = Answer(checkmark: newValue, text: current.text)
                                        responseViewModel.updateAnswer(
                                            surveyID: survey.id,
                                            storeID: store.id,
                                            questionID: question.id,
                                            answer: updated)
                                    }
                                )) {
                                    Text("Yes/No")
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            }

                            
                                
                                if question.hasTextField {
                                    
                                    HStack {
                                        Image(systemName: "square.and.pencil")
                                        TextField("Answer here...", text: Binding(
                                            get: { storeResponse.answers[question.id]?.text ?? "" },
                                            set: { newValue in
                                                let current = storeResponse.answers[question.id] ?? Answer()
                                                let updated = Answer(checkmark: current.checkmark, text: newValue)
                                                responseViewModel.updateAnswer(
                                                    surveyID: survey.id,
                                                    storeID: store.id,
                                                    questionID: question.id,
                                                    answer: updated)
                                            }
                                        ))
                                    }
                                    .padding(10)
                                    .background(Color.card).opacity(0.5)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .foregroundStyle(Color.text)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                    
                                    
                                }
                            
                            
                            
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.secondary.opacity(0.12))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Survey")
        .background(Color.background.ignoresSafeArea())
    }
}


//struct SurveyResponseView: View {
//    let survey: SurveyForm
//    let store: Store
//    @ObservedObject var responseViewModel: SurveyResponseViewModel
//    
//    var body: some View {
//        let storeResponse = responseViewModel.response(for: survey.id, storeID: store.id)
//        
//        Form {
//            ForEach(survey.questions) { question in
//                Section(header: Text("It's in Demo?")) {
//                    if question.hasCheckmark {
//                        Toggle(question.text, isOn: Binding(
//                            get: { storeResponse.answers[question.id]?.checkmark ?? false },
//                            set: { newValue in
//                                let current = storeResponse.answers[question.id] ?? Answer()
//                                let updated = Answer(checkmark: newValue, text: current.text)
//                                responseViewModel.updateAnswer(
//                                    surveyID: survey.id,
//                                    storeID: store.id,
//                                    questionID: question.id,
//                                    answer: updated)
//                            }
//                        ))
//                    }
//                    if question.hasTextField {
//                        TextField("Imei number", text: Binding(
//                            get: { storeResponse.answers[question.id]?.text ?? "" },
//                            set: { newValue in
//                                let current = storeResponse.answers[question.id] ?? Answer()
//                                let updated = Answer(checkmark: current.checkmark, text: newValue)
//                                responseViewModel.updateAnswer(
//                                    surveyID: survey.id,
//                                    storeID: store.id,
//                                    questionID: question.id,
//                                    answer: updated
//                                )
//                            }
//                        ))
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("it's on Demo?")
//        
//    }
//}

#Preview {
    // Store de ejemplo
    let store = Store(name: "EG Barkarby", location: "Barkarby")
    
    // Survey de ejemplo
    let survey = SurveyForm(
        title: "Teléfonos en tienda",
        questions: [
            SurveyQuestion(text: "Pixel 9a", hasCheckmark: true, hasTextField: true),
            SurveyQuestion(text: "Pixel 9 Pro", hasCheckmark: true, hasTextField: false)
        ]
    )
    
    // ViewModel de respuestas
    let responseVM = SurveyResponseViewModel()

    return SurveyResponseView(
        survey: survey,
        store: store,
        responseViewModel: responseVM
    )
}



