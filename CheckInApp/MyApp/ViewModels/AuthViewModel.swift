//
//  AuthViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-14.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        checkUserSession()
    }

    func checkUserSession() {
        if let currentUser = Auth.auth().currentUser {
            self.user = UserModel(id: currentUser.uid, email: currentUser.email ?? "", displayName: currentUser.displayName)
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
                    self.user = UserModel(id: user.uid, email: user.email ?? "", displayName: user.displayName)
                }
            }
        }
    }

    func register(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self.user = UserModel(id: user.uid, email: user.email ?? "", displayName: user.displayName)
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
