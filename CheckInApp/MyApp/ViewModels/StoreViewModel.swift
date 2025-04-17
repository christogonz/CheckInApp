//
//  StoreViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import Foundation
import Combine
import FirebaseAuth

// MARK: - StoreViewModel usando Firestore
class StoreViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()
    let repository = StoreRepository()

    var filteredStores: [Store] {
        if searchText.isEmpty {
            return stores
        } else {
            return stores.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    init() {
        repository.$stores
            .receive(on: DispatchQueue.main)
            .assign(to: &$stores)
    }

    func addStore(_ store: Store) {
        repository.addStore(store)
    }

    func deleteStore(_ store: Store) {
        repository.deleteStore(store)
    }

    func updateStore(storeId: String, name: String?, location: String?) {
        repository.updateStoreFields(storeId: storeId, name: name, location: location)
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
