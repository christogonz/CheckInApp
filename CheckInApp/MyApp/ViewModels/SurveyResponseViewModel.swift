//
//  SurveyResponseViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SurveyResponseViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let collection = "surveyResponses"

    @Published var responses: [SurveyResponse] = []
    private var listener: ListenerRegistration?

    init() {
        fetchResponses()
    }

    func fetchResponses() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        listener?.remove()

        listener = db.collection(collection)
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching responses: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.responses = documents.compactMap { doc in
                    try? doc.data(as: SurveyResponse.self)
                }
            }
    }

    func response(for surveyID: String, storeID: String) -> SurveyResponse {
        guard let userID = Auth.auth().currentUser?.uid else {
            return SurveyResponse(surveyID: surveyID, storeID: storeID, userID: "", answers: [:])
        }

        if let existing = responses.first(where: { $0.surveyID == surveyID && $0.storeID == storeID && $0.userID == userID }) {
            return existing
        } else {
            let new = SurveyResponse(surveyID: surveyID, storeID: storeID, userID: userID, answers: [:])
            saveResponse(new)
            return new
        }
    }

    func updateAnswer(surveyID: String, storeID: String, questionID: String, answer: Answer) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        if let index = responses.firstIndex(where: { $0.surveyID == surveyID && $0.storeID == storeID && $0.userID == userID }) {
            responses[index].answers[questionID] = answer
            saveResponse(responses[index])
        } else {
            var new = SurveyResponse(surveyID: surveyID, storeID: storeID, userID: userID, answers: [:])
            new.answers[questionID] = answer
            saveResponse(new)
        }
    }

    private func saveResponse(_ response: SurveyResponse) {
        if let docID = response.id {
            do {
                try db.collection(collection).document(docID).setData(from: response)
            } catch {
                print("Error updating response: \(error.localizedDescription)")
            }
        } else {
            do {
                _ = try db.collection(collection).addDocument(from: response)
            } catch {
                print("Error saving new response: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        listener?.remove()
    }
}
