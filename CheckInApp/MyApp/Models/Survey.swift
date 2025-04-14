//
//  Survey.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation


struct SurveyForm: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var questions: [SurveyQuestion]
}

struct SurveyQuestion: Identifiable, Codable, Equatable {
    var id = UUID()
    var text: String
    var hasCheckmark: Bool
    var hasTextField: Bool
}

//----- Response
struct SurveyResponse: Codable, Equatable {
    var surveyID: UUID
    var storeID: UUID
    var answers: [UUID: Answer] // preguntaID : respuesta
}

struct Answer: Codable, Equatable {
    var checkmark: Bool?
    var text: String?
}
