//
//  session.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-16.
//

import Foundation
import FirebaseFirestore

struct Session: Codable {
    var checkIn: Date?
    var checkOut: Date?
    var store: Store?
}


struct SessionRecord: Identifiable, Codable {
    @DocumentID var id: String?
    var storeID: String
    var checkIn: Date
    var checkOut: Date
    var userID: String
}

