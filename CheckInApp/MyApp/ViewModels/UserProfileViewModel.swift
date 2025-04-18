//
//  UserProfileViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-17.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserProfileViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var isLoading = false
    

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    var userID: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - Cargar información del usuario
    func loadUserData() {
        guard let userID else { return }

        db.collection("users").document(userID).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data() {
                self?.firstName = data["firstName"] as? String ?? ""
                self?.lastName = data["lastName"] as? String ?? ""
                
                if let photoURL = data["photoURL"] as? String {
                    self?.loadProfileImage(from: photoURL)
                }
            } else {
                print("❌ Error al cargar datos de usuario: \(error?.localizedDescription ?? "Unknown")")
            }
        }
    }

    // MARK: - Guardar nombre y apellido
    func updateName(firstName: String, lastName: String) {
        guard let userID else { return }

        db.collection("users").document(userID).setData([
            "firstName": firstName,
            "lastName": lastName
        ], merge: true)
    }

    // MARK: - Subir imagen de perfil
    func uploadProfileImage(_ image: UIImage) {
        guard let userID,
              let imageData = image.jpegData(compressionQuality: 0.8)
        else { return }

        let ref = storage.reference().child("profile_images/\(userID).jpg")
        isLoading = true

        ref.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard error == nil else {
                print("❌ Error al subir imagen: \(error!.localizedDescription)")
                self?.isLoading = false
                return
            }

            ref.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("❌ Error al obtener URL: \(error?.localizedDescription ?? "Unknown")")
                    self?.isLoading = false
                    return
                }

                self?.updateProfilePhotoURL(downloadURL.absoluteString)
                self?.image = image
                self?.isLoading = false
            }
        }
    }

    private func updateProfilePhotoURL(_ urlString: String) {
        guard let userID else { return }

        db.collection("users").document(userID).setData([
            "photoURL": urlString
        ], merge: true)

        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.photoURL = URL(string: urlString)
            changeRequest.commitChanges(completion: nil)
        }
    }

    // MARK: - Descargar imagen desde URL
    func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
    
    func updateUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName
        ]

        Firestore.firestore().collection("users").document(userID).setData(userData, merge: true) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated")
            }
        }
    }
}
