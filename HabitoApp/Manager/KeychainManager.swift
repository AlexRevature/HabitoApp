//
//  KeychainManager.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import Foundation

class KeychainManager {

    private init() {}

    static func checkForID(id: String) -> Bool {
        let request: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id.lowercased(),
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        let status = SecItemCopyMatching(request as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func saveCredentials(id: String, password: String) throws {

        let attributes: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id.lowercased(),
            kSecValueData as String: password.data(using: .utf8)!
        ]

        let status = SecItemAdd(attributes as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateKey
        }

        guard status != errSecSuccess else {
            throw KeychainError.failure
        }

    }

    static func verifyCredentials(id: String, password: String) throws -> Bool {
        let request: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id.lowercased(),
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var response: CFTypeRef?
        let status = SecItemCopyMatching(request as CFDictionary, &response)

        guard status != errSecItemNotFound else {
            throw KeychainError.missingKey
        }

        guard status == noErr else {
            throw KeychainError.failure
        }

        let data = response as! [String: Any]
        let passwordData = data[kSecValueData as String] as! Data
        let keychainPassword = String(data: passwordData, encoding: .utf8)

        guard let keychainPassword else {
            throw KeychainError.system
        }

        return keychainPassword == password
    }

    static func deleteCredentials() throws {

        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny
        ] as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.failure
        }

    }
}

enum KeychainError: Error {
    case duplicateKey
    case missingKey
    case success
    case failure
    case system
}
