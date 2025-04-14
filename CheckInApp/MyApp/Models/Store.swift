//
//  Store.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-03-31.
//

import Foundation

// MARK: - Model
struct Store: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var location: String
    
    init(id: UUID = UUID(), name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }
}

struct Session: Codable {
    var checkIn: Date?
    var checkOut: Date?
    var store: Store?
}

struct Survey: Codable {
    var question1: Bool
    var question2: Bool
    var question3: Bool
}

struct SessionRecord: Identifiable, Codable {
    var id = UUID()
    let store: Store
    var checkIn: Date
    var checkOut: Date
}


