//
//  Survey.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation
import FirebaseFirestore

struct SurveyForm: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var questions: [SurveyQuestion]

    // Computed ID for Identifiable fallback
    var safeID: String { id ?? UUID().uuidString }
}


struct SurveyQuestion: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var text: String
    var hasCheckmark: Bool
    var hasTextField: Bool
}


struct SurveyResponse: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var surveyID: String
    var storeID: String
    var userID: String
    var answers: [String: Answer]

    // Computed ID for Identifiable fallback
    var safeID: String { id ?? UUID().uuidString }
}

struct Answer: Codable, Equatable {
    var checkmark: Bool? = false
    var text: String? = ""
}





