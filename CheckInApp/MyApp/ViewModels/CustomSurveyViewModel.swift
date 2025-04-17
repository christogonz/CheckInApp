//
//  CustomSurveyViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation
import Combine

class CustomSurveyViewModel: ObservableObject {
    @Published var surveys: [SurveyForm] = []
    
    private let repository = SurveyRepository()

    init() {
        fetchSurveys()
    }

    func fetchSurveys() {
        repository.fetchSurveys { [weak self] fetched in
            DispatchQueue.main.async {
                self?.surveys = fetched
            }
        }
    }

    func addSurvey(_ survey: SurveyForm) {
        repository.addSurvey(survey)
    }

    func updateSurvey(original: SurveyForm, updated: SurveyForm) {
        repository.updateSurvey(updated)
    }

    func deleteSurvey(by survey: SurveyForm) {
        repository.deleteSurvey(survey)
    }
}
