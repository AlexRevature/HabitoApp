//
//  DBManager.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import Foundation
import SQLite3

class DBManager {

    var db: OpaquePointer?
    static let shared = DBManager(filename: "HabitoDB.sqlite")

    init(filename: String) {
        createDatabase(filename: filename)
    }

    func createDatabase(filename: String) {
        let fPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(filename)

        if sqlite3_open(fPath.path, &db) != SQLITE_OK {
            print("Error")
        }
    }
}
