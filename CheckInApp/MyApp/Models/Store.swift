//
//  Store.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

//
//  Store.swift
//  CheckInApp
//

import Foundation
import FirebaseFirestore

struct Store: Identifiable, Codable, Equatable {
    var id: String?
    var name: String
    var location: String
    var chain: String? // Opcional
    
    init(id: String? = nil, name: String, location: String, chain: String? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.chain = chain
    }
}
//struct Session: Codable {
//    var checkIn: Date?
//    var checkOut: Date?
//    var store: Store?
//}
//
//
//struct SessionRecord: Identifiable, Codable {
//    @DocumentID var id: String? 
//    var storeID: String
//    var checkIn: Date
//    var checkOut: Date
//    var userID: String
//}
//

