//
//  ImageUploadViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-17.

//import SwiftUI
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseFirestore
//import UIKit
//
//class ImageUploadViewModel: ObservableObject {
//    @Published var image: UIImage?
//
//    private let storage = Storage.storage()
//    private let db = Firestore.firestore()
//
//    func uploadProfileImage(_ image: UIImage) {
//        guard let user = Auth.auth().currentUser else { return }
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
//
//        let ref = storage.reference().child("profile_images/\(user.uid).jpg")
//        ref.putData(imageData, metadata: nil) { [weak self] metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error.localizedDescription)")
//                return
//            }
//
//            ref.downloadURL { url, error in
//                if let error = error {
//                    print("Error fetching download URL: \(error.localizedDescription)")
//                    return
//                }
//
//                if let downloadURL = url {
//                    self?.updateUserProfile(with: downloadURL)
//                    self?.savePhotoURLToFirestore(downloadURL)
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//
//    private func updateUserProfile(with url: URL) {
//        let request = Auth.auth().currentUser?.createProfileChangeRequest()
//        request?.photoURL = url
//        request?.commitChanges { error in
//            if let error = error {
//                print("Error updating profile image URL in Auth: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func savePhotoURLToFirestore(_ url: URL) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        db.collection("users").document(uid).updateData([
//            "photoURL": url.absoluteString
//        ]) { error in
//            if let error = error {
//                print("Error saving photoURL in Firestore: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func loadProfileImage(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            if let data = data, let uiImage = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self?.image = uiImage
//                }
//            } else if let error = error {
//                print("Error loading image from URL: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//}
