//
//  StoreViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import Foundation
import Combine

// MARK: - ViewModels.swift
class StoreViewModel: ObservableObject {
    @Published var defaultStores: [Store] = []
    
    @Published var userStores: [Store] {
        didSet {
            UserDefaults.save(userStores, key: "userStores")
        }
    }
    
    
    @Published var searchText = ""
    
    var allStores: [Store] {
        defaultStores + userStores
    }
    
    var filteredStores: [Store] {
        if searchText.isEmpty {
            return allStores
        } else {
            return allStores.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init() {
        self.userStores = UserDefaults.load(key: "userStores", defaultValue: [])
    }
}


//-- SessionViewModel
class SessionViewModel: ObservableObject {
    @Published var session: Session {
        didSet { saveSession() }
    }
    
    @Published var history: [SessionRecord] {
        didSet { saveHistory() }
    }
    
    @Published var elapsedTime: TimeInterval = 0
        private var timerCancellable: AnyCancellable?
    
    @Published var surveys: [String: Survey] {
        didSet { saveSurveys() }
    }

    init() {
        self.session = UserDefaults.load(key: "session", defaultValue: Session(checkIn: nil, checkOut: nil, store: nil))
        self.surveys = UserDefaults.load(key: "surveys", defaultValue: [:])
        self.history = UserDefaults.load(key: "history", defaultValue: [])

        if session.checkIn != nil && session.checkOut == nil {
            startTimer()
        }
    }


    func checkIn(to store: Store) {
        session = Session(checkIn: Date(), checkOut: nil, store: store)
        startTimer()
    }

    func checkOut() {
        guard let store = session.store, let checkIn = session.checkIn else { return }
        let record = SessionRecord(store: store, checkIn: checkIn, checkOut: Date())
        history.append(record)
        session.checkOut = Date()
        saveSession()
        saveHistory()
    }
    
    
    private func startTimer() {
        stopTimer()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self,
                      let start = self.session.checkIn,
                      self.session.checkOut == nil else { return }
                self.elapsedTime = now.timeIntervalSince(start)
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func saveHistory() {
        UserDefaults.save(history, key: "history")
    }
   

    func toggleSurvey(for store: Store, question: KeyPath<Survey, Bool>, setTo value: Bool) {
        let id = store.id.uuidString
        var survey = surveys[id] ?? Survey(question1: false, question2: false, question3: false)
        if question == \Survey.question1 { survey.question1 = value }
        else if question == \Survey.question2 { survey.question2 = value }
        else if question == \Survey.question3 { survey.question3 = value }
        surveys[id] = survey
    }

    private func saveSession() {
        UserDefaults.save(session, key: "session")
    }

    private func saveSurveys() {
        UserDefaults.save(surveys, key: "surveys")
    }
}


// MARK: - UserDefaults+Codable.swift
extension UserDefaults {
    static func save<T: Codable>(_ object: T, key: String) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load<T: Codable>(key: String, defaultValue: T) -> T {
        guard let data = UserDefaults.standard.data(forKey: key),
              let object = try? JSONDecoder().decode(T.self, from: data) else {
            return defaultValue
        }
        return object
    }
}
