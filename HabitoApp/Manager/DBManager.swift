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
    static let shared = DBManager()

    private init() {
        createDatabase()
    }

    func createDatabase() {
        let fPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("HabitoDB.sqlite")

        if sqlite3_open(fPath.path, &db) != SQLITE_OK {
            print("Error")
        }
    }
}
