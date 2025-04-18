//
//  StorageRepository.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-17.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageRepository {
    private let storage = Storage.storage()

    // MARK: - Subir imagen de perfil
    func uploadProfileImage(_ image: UIImage, userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        uploadImage(image, path: "profile_images/", identifier: userID, completion: completion)
    }

    // MARK: - Subir imagen de tienda (ejemplo futuro)
    func uploadStoreImage(_ image: UIImage, storeID: String, completion: @escaping (Result<String, Error>) -> Void) {
        uploadImage(image, path: "store_images/", identifier: storeID, completion: completion)
    }

    // MARK: - Función genérica reutilizable
    private func uploadImage(_ image: UIImage, path: String, identifier: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen."])))
            return
        }

        let ref = storage.reference().child("\(path)\(identifier).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        ref.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                }
            }
        }
    }
}
