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
    var chain: String? 
    
    init(id: String? = nil, name: String, location: String, chain: String? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.chain = chain
    }
}

