//
//  SurveyRepository.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//

// SurveyRepository.swift
import Foundation
import FirebaseFirestore

class SurveyRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection = "surveys"

    func addSurvey(_ survey: SurveyForm) {
        do {
            _ = try db.collection(collection).addDocument(from: survey)
        } catch {
            print("❌ Error adding survey: \(error.localizedDescription)")
        }
    }

    func updateSurvey(_ survey: SurveyForm) {
        guard let id = survey.id else {
            print("❌ Survey has no ID to update.")
            return
        }

        do {
            try db.collection(collection).document(id).setData(from: survey)
        } catch {
            print("❌ Error updating survey: \(error.localizedDescription)")
        }
    }

    func deleteSurvey(_ survey: SurveyForm) {
        guard let id = survey.id else { return }
        db.collection(collection).document(id).delete { error in
            if let error = error {
                print("❌ Error deleting survey: \(error.localizedDescription)")
            }
        }
    }

    func fetchSurveys(completion: @escaping ([SurveyForm]) -> Void) {
        db.collection(collection).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("❌ Error fetching surveys: \(error?.localizedDescription ?? "Unknown")")
                completion([])
                return
            }

            let surveys = documents.compactMap { try? $0.data(as: SurveyForm.self) }
            completion(surveys)
        }
    }
}
