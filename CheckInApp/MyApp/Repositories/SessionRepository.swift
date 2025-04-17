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

    @Published var sessions: [SessionRecord] = []

    var sessionsPublisher: AnyPublisher<[SessionRecord], Never> {
        $sessions.eraseToAnyPublisher()
    }

    init() {
        fetchUserSessions()
    }

    func fetchUserSessions() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            self.sessions = []
            return
        }

        db.collection(collection)
            .whereField("userID", isEqualTo: uid)
            .order(by: "checkIn", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching sessions: \(error.localizedDescription)")
                    return
                }

                self.sessions = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: SessionRecord.self)
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
