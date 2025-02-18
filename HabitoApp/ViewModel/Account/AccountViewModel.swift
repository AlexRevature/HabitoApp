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
class AccountViewModel {

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

    func verifyInformation(name: String, email: String, phone: String, password: String, passwordVerify: String) throws {
        if name.isEmpty {
            throw AccountError.name(message: "Name may not be empty")
        }

        if email.isEmpty {
            throw AccountError.email(message: "Email may not be empty")
        }
        if !AccountViewModel.checkEmail(email: email) {
            throw AccountError.email(message: "Invalid email address")
        }
        guard UserManager.shared.fetchID(email: email) == nil else {
            throw AccountError.email(message: "Email already in use")
        }

        if password.isEmpty {
            throw AccountError.password(message: "Password may not be empty")
        }
        if password.count < 8 {
            throw AccountError.password(message: "Password may not be empty")
        }
        if !AccountViewModel.checkNumPassword(password: password) {
            throw AccountError.password(message: "Password may not be empty")
        }
        if !AccountViewModel.checkSymbolPassword(password: password) {
            throw AccountError.password(message: "Password may not be empty")
        }

        if password != passwordVerify {
            throw AccountError.password(message: "Passwords do not match")
        }
    }

    func createUser(name: String, email: String, phone: String, password: String, keychain: Bool = true) throws -> User {

        let id = UserManager.shared.insertData(name: name, email: email, phone: phone)
        guard let id else {
            throw AccountError.system(message: "Unable to create user")
        }

        if keychain {
            do {
                try KeychainManager.saveCredentials(id: "\(id)", password: password)
            } catch {
                throw AccountError.system(message: "Keychain error, please contact the developers")
            }
        }

        return User(id: id, name: name, email: email, phone: phone)
    }

    func verifyUserByEmail(email: String, password: String) throws -> User {
        if email.isEmpty {
            throw AccountError.email(message: "Missing email")
        }
        if password.isEmpty {
            throw AccountError.password(message: "Missing password")
        }

        guard let id = UserManager.shared.fetchID(email: email) else {
            throw AccountError.email(message: "Account does not exist")
        }

        return try verifyUserByID(id: id, password: password)
    }

    func verifyUserByID(id: Int, password: String) throws -> User {
        let isValid: Bool
        do {
            isValid = try KeychainManager.verifyCredentials(id: "\(id)", password: password)
        } catch {
            throw AccountError.system(message: "Incorrect signin method")
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

    // TODO: Save everything to database here
    func logoutUser() {
        @AppStorage("currentID") var currentID: Int?
        currentID = nil
        currentUser = nil
    }

    func deleteUser() {
        @AppStorage("currentID") var currentID: Int?
        currentID = nil
        
        guard let userID = currentUser?.id else { return }
        UserManager.shared.deleteData(id: userID)
        HabitManager.shared.deleteDataByUser(userID: userID)
        currentUser = nil
    }
}

enum AccountError: Error {
    case name(message: String)
    case email(message: String)
    case phone(message: String)
    case password(message: String)
    case verification(message: String)
    case system(message: String)
}
