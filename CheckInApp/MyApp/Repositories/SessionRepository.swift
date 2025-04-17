//
//  SessionRepository.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//
// SessionRepository.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class SessionRepository: ObservableObject {
    private let db = Firestore.firestore()
        private let collection = "sessions"
        private let userID: String

        @Published var sessions: [SessionRecord] = []

        var sessionsPublisher: AnyPublisher<[SessionRecord], Never> {
            $sessions.eraseToAnyPublisher()
        }

        init(userID: String) {
            self.userID = userID
            fetchUserSessions(for: userID)
        }

    func fetchUserSessions(for userID: String) {
        db.collection(collection)
            .whereField("userID", isEqualTo: userID)
            .order(by: "checkIn", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching sessions: \(error.localizedDescription)")
                    return
                }

                self.sessions = snapshot?.documents.compactMap {
                    try? $0.data(as: SessionRecord.self)
                } ?? []
            }
    }

    func addSession(_ session: SessionRecord) {
        do {
            _ = try db.collection(collection).addDocument(from: session)
        } catch {
            print("Error adding session: \(error.localizedDescription)")
        }
    }
}
