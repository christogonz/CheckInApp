//
//  User.swift
//  CheckInApp
//
//  Created by Christopher Gonzalez on 2025-04-14.
//

import Foundation

struct UserModel: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String?
    var photoURL: String?
    var firstName: String?
    var lastName: String?

    var uid: String { id }
}
