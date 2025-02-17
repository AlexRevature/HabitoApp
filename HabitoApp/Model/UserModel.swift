//
//  UserModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation

@Observable
class User: Equatable {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var image: Data?

    init(id: Int, name: String, email: String, phone: String, image: Data? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.image = image
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
            && lhs.email == rhs.email && lhs.phone == rhs.phone
                && lhs.image == rhs.image
    }
}
