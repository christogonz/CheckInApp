//
//  CustomSurveyViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-10.
//

import Foundation


class CustomSurveyViewModel: ObservableObject {
    @Published var surveys: [SurveyForm] {
        didSet {
            UserDefaults.save(surveys, key: "customSurveys")
        }
    }
    
    init() {
        self.surveys = UserDefaults.load(key: "customSurveys", defaultValue: [])
    }
    
    func addSurvey(_ survey: SurveyForm) {
        surveys.append(survey)
    }
    
    func updateSurvey(original: SurveyForm, updated: SurveyForm) {
        if let index = surveys.firstIndex(of: original) {
            surveys[index] = updated
        }
    }
    
    func deleteSurvey(by survey: SurveyForm) {
        if let index = surveys.firstIndex(of: survey) {
            surveys.remove(at: index)
        }
    }}
