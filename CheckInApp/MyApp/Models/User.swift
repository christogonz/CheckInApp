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
}
