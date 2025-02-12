//
//  UserModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation

class User {
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
}
