//
//  SessionViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//

// SessionViewModel.swift
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class SessionViewModel: ObservableObject {
    @Published var session: Session?
    @Published var history: [SessionRecord] = []
    @Published var elapsedTime: TimeInterval = 0

    private var timerCancellable: AnyCancellable?
    private let repository = SessionRepository()
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()

    init() {
        fetchActiveSessionFromFirestore()
        listenToHistory()
    }

    private func listenToHistory() {
        repository.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$history)
    }

    func checkIn(to store: Store) {
        session = Session(checkIn: Date(), checkOut: nil, store: store)
        startTimer()
        saveActiveSessionToFirestore()
    }

    func checkOut() {
        guard let session = session,
              let store = session.store,
              let checkIn = session.checkIn,
              let storeID = store.id else { return }

        let checkOutDate = Date()
        let record = SessionRecord(
            storeID: storeID,
            checkIn: checkIn,
            checkOut: checkOutDate,
            userID: Auth.auth().currentUser?.uid ?? "unknown"
        )

        repository.addSession(record)
        self.session = nil
        elapsedTime = 0
        clearActiveSessionFromFirestore()
    }

    private func startTimer() {
        stopTimer()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self,
                      let start = self.session?.checkIn,
                      self.session?.checkOut == nil else { return }
                self.elapsedTime = now.timeIntervalSince(start)
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func lastSession(for storeID: String) -> SessionRecord? {
        return history
            .filter { $0.storeID == storeID }
            .sorted(by: { $0.checkIn > $1.checkIn })
            .first
    }

    private func saveActiveSessionToFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let storeID = session?.store?.id else { return }
        guard let checkIn = session?.checkIn else { return }

        let data: [String: Any] = [
            "storeID": storeID,
            "checkIn": checkIn,
            "userID": uid
        ]

        db.collection("activeSessions").document(uid).setData(data) { error in
            if let error = error {
                print("Error saving active session: \(error.localizedDescription)")
            }
        }
    }

    private func clearActiveSessionFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("activeSessions").document(uid).delete { error in
            if let error = error {
                print("Error removing active session: \(error.localizedDescription)")
            }
        }
    }

    private func fetchActiveSessionFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("activeSessions").document(uid).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(),
                  let storeID = data["storeID"] as? String,
                  let checkIn = (data["checkIn"] as? Timestamp)?.dateValue() else {
                return
            }

            let store = Store(id: storeID, name: "", location: "")
            self?.session = Session(checkIn: checkIn, checkOut: nil, store: store)
            self?.startTimer()
        }
    }
}
