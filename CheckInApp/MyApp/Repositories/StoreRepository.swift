//
//  StoreRepository.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//


import Foundation
import FirebaseFirestore

class StoreRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collection = "stores"
    
    @Published var stores: [Store] = []

    init() {
        fetchStores()
    }

    func fetchStores() {
        db.collection(collection).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching stores: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.stores = documents.compactMap { doc in
                var store = try? doc.data(as: Store.self)
                store?.id = doc.documentID
                return store
            }
        }
    }


    func addStore(_ store: Store) {
        do {
            var newStore = store
            newStore.id = nil
            _ = try db.collection(collection).addDocument(from: newStore)
        } catch {
            print("Error adding store: \(error.localizedDescription)")
        }
    }

    
    func updateStoreFields(storeId: String, name: String?, location: String?, completion: ((Error?) -> Void)? = nil) {
        var data: [String: Any] = [:]
        if let name = name { data["name"] = name }
        if let location = location { data["location"] = location }

        db.collection(collection).document(storeId).updateData(data, completion: completion)
    }

    
    func deleteStore(_ store: Store) {
        guard let id = store.id else { return }
        db.collection(collection).document(id).delete()
    }
}
