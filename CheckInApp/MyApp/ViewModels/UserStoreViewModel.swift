//
//  UserStoreViewModel.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import Foundation

class UserStoreViewModel: ObservableObject {
    @Published var userStores: [Store] {
        didSet {
            UserDefaults.save(userStores, key: "userStores")
        }
    }
    
    init() {
        self.userStores = UserDefaults.load(key: "userStores", defaultValue: [])
    }
    
    func addStore(name: String, location: String) {
        let newStore = Store(name: name, location: location)
        userStores.append(newStore)
    }
    
    func deleteStore(at offsets: IndexSet) {
        userStores.remove(atOffsets: offsets)
    }
}
