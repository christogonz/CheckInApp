//
//  AuthViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()

    init() {
        checkUserSession()
    }

    func checkUserSession() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserData(uid: currentUser.uid)
        } else {
            self.user = nil
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self.fetchUserData(uid: user.uid)
                }
            }
        }
    }

    func register(email: String, password: String, firstName: String, lastName: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    let newUser = UserModel(
                        id: user.uid,
                        email: email,
                        displayName: "\(firstName) \(lastName)",
                        photoURL: nil,
                        firstName: firstName,
                        lastName: lastName
                    )

                    self.saveUserToFirestore(user: newUser)
                }
            }
        }
    }

    private func saveUserToFirestore(user: UserModel) {
        do {
            try db.collection("users").document(user.id).setData(from: user)
            self.user = user
        } catch {
            self.errorMessage = "Error saving user: \(error.localizedDescription)"
        }
    }

    private func fetchUserData(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
                return
            }

            if let document = snapshot, let data = try? document.data(as: UserModel.self) {
                DispatchQueue.main.async {
                    self.user = data
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
