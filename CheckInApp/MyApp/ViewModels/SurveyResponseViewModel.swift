//
//  SurveyResponseViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation


class SurveyResponseViewModel: ObservableObject {
    @Published var responses: [SurveyResponse] {

        
        didSet {
            UserDefaults.save(responses, key: "surveyResponses")
        }
    }

    
    init() {
        self.responses = UserDefaults.load(key: "surveyResponses", defaultValue: [])
    }

    func response(for surveyID: UUID, storeID: UUID) -> SurveyResponse {
        if let existing = responses.first(where: { $0.surveyID == surveyID && $0.storeID == storeID }) {
            return existing
        } else {
            let new = SurveyResponse(surveyID: surveyID, storeID: storeID, answers: [:])
            responses.append(new)
            return new
        }
    }

    func updateAnswer(surveyID: UUID, storeID: UUID, questionID: UUID, answer: Answer) {
        if let index = responses.firstIndex(where: { $0.surveyID == surveyID && $0.storeID == storeID }) {
            responses[index].answers[questionID] = answer
        } else {
            var new = SurveyResponse(surveyID: surveyID, storeID: storeID, answers: [:])
            new.answers[questionID] = answer
            responses.append(new)
        }
    }
}

