//
//  AccountViewModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class AccountViewModel : ObservableObject{

    var loggedIn = false
    var currentUser: User?

    static private func checkEmail(email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    static private func checkNumPassword(password: String) -> Bool {
        let numberMatch = /[0-9]/
        return !(password.matches(of: numberMatch).isEmpty)
    }

    static private func checkSymbolPassword(password: String) -> Bool {
        let symbolMatch = /[^(A-Za-z0-9)]/
        return !(password.matches(of: symbolMatch).isEmpty)
    }

    func createUser(username: String, email: String, phone: String, password: String, passwordVerify: String) throws -> User {

        if username.isEmpty {
            throw AccountError.username(message: "Username may not be empty")
        }
        if KeychainManager.checkForID(id: username) {
            throw AccountError.username(message: "Username already in use")
        }

        if email.isEmpty {
            throw AccountError.email(message: "Email may not be empty")
        }
        if !AccountViewModel.checkEmail(email: email) {
            throw AccountError.email(message: "Invalid email address")
        }

        if password.isEmpty {
            throw AccountError.password(message: "Password may not be empty")
        }

        if password != passwordVerify {
            throw AccountError.password(message: "Passwords do not match")
        }

        let id = UserManager.shared.insertData(username: username, email: email, phone: phone)
        guard let id else {
            throw AccountError.system(message: "Unable to create user")
        }

        do {
            try KeychainManager.saveCredentials(id: "\(id)", password: password)
        } catch {
            throw AccountError.system(message: "Keychain error, please contact the developers")
        }

        return User(id: id, username: username, email: email, phone: phone)
    }

    func verifyUserByName(username: String, password: String) throws -> User {
        if username.isEmpty {
            throw AccountError.username(message: "Missing username")
        }
        if password.isEmpty {
            throw AccountError.password(message: "Missing password")
        }

        guard let id = UserManager.shared.fetchID(username: username) else {
            throw AccountError.username(message: "Username does not exist")
        }

        return try verifyUserByID(id: id, password: password)
    }

    func verifyUserByID(id: Int, password: String) throws -> User {
        let isValid: Bool
        do {
            isValid = try KeychainManager.verifyCredentials(id: "\(id)", password: password)
        } catch {
            throw AccountError.system(message: "Keychain error, please contact developers")
        }
        if !isValid {
            throw AccountError.verification(message: "Invalid credentials")
        }

        guard let user = UserManager.shared.fetchDataById(id: id) else {
            throw AccountError.system(message: "System Error")
        }

        return user
    }

    func retrieveUserByID(id: Int) throws -> User {
        guard let user = UserManager.shared.fetchDataById(id: id) else {
            throw AccountError.system(message: "System Error")
        }
        return user
    }

    func logoutUser() {
        @AppStorage("currentID") var currentID: Int?
        currentID = nil
        currentUser = nil
    }
}

enum AccountError: Error {
    case username(message: String)
    case email(message: String)
    case phone(message: String)
    case password(message: String)
    case verification(message: String)
    case system(message: String)
}
