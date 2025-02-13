//
//  UserModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation

class User: Equatable {
    var id: Int
    var username: String
    var email: String
    var phone: String
    var image: Data

    init(id: Int, username: String, email: String, phone: String, image: Data) {
        self.id = id
        self.username = username
        self.email = email
        self.phone = phone
        self.image = image
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id && lhs.username == rhs.username
            && lhs.email == rhs.email && lhs.phone == rhs.phone
                && lhs.image == rhs.image
    }
}
