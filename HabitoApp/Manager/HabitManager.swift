//
//  HabitManager.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import Foundation
import SQLite3

class HabitManager {

    let manager: DBManager
    let db: OpaquePointer?
    static let shared = HabitManager(manager: DBManager.shared)

    init(manager: DBManager) {
        self.manager = manager
        self.db = manager.db
        createTable()
    }

    func createTable() {

        // TODO: Remove for final deployment, for now it's convenient for previews
//        dropTable()

        let sql = """
            CREATE TABLE if not exists HABIT (
                id INTEGER PRIMARY KEY,
                type INTEGER,
                count INTEGER,
                total INTEGER,
                userID INTEGER NULL,
                setDate TEXT,
                FOREIGN KEY(userID) REFERENCES USER(userID)
            )
            """
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
    }

    func insertData(type: HabitType, count: Int, total: Int, userID: Int? = nil, date: String) -> Int? {
        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        let query = "INSERT INTO HABIT(type,count,total,userID,setDate) VALUES(?,?,?,?,?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 1, Int32(type.rawValue)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 2, Int32(count)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 3, Int32(total)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if let userID {
            if sqlite3_bind_int(stmt, 4, Int32(userID)) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
                return nil
            }
        } else {
            sqlite3_bind_null(stmt, 4)
        }

        if sqlite3_bind_text(stmt, 5, NSString(string: date).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        return Int(sqlite3_last_insert_rowid(db))

    }

    func fetchData() -> [Habit]? {

        var habitList = [Habit]()
        let query = "SELECT * FROM HABIT"
        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))

            let numType = Int(sqlite3_column_int(stmt, 1))
            let count = Int(sqlite3_column_int(stmt, 2))
            let total = Int(sqlite3_column_int(stmt, 3))
            let userID = Int(sqlite3_column_int(stmt, 4))
            let date = String(cString: sqlite3_column_text(stmt, 5))

            habitList.append(Habit(id: id, type: HabitType(rawValue: numType) ?? .invalid, count: count, total: total, userID: userID, date: date))
        }

        return habitList
    }

    func fetchDataByUserDate(userID: Int, date: String) -> [Habit]? {
        var habitList = [Habit]()
        let query = "SELECT * FROM HABIT WHERE userID = ? AND setDate = ?"
        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 1, Int32(userID)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 2, NSString(string: date).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let numType = Int(sqlite3_column_int(stmt, 1))

            let count = Int(sqlite3_column_int(stmt, 2))
            let total = Int(sqlite3_column_int(stmt, 3))

            let userID = Int(sqlite3_column_int(stmt, 4))
            let date = String(cString: sqlite3_column_text(stmt, 5))

            habitList.append(Habit(id: id, type: HabitType(rawValue: numType) ?? .invalid, count: count, total: total, userID: userID, date: date))
        }

        if habitList.count == 0 {
            return nil
        }

        return habitList
    }

    func fetchDataById(id: Int) -> Habit? {
        let query = "SELECT * FROM HABIT WHERE id = ?"
        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let numType = Int(sqlite3_column_int(stmt, 1))

            let count = Int(sqlite3_column_int(stmt, 2))
            let total = Int(sqlite3_column_int(stmt, 3))

            let userID = Int(sqlite3_column_int(stmt, 4))
            let date = String(cString: sqlite3_column_text(stmt, 5))

            return Habit(id: id, type: HabitType(rawValue: numType) ?? .invalid, count: count, total: total, userID: userID, date: date)
        }

        return nil
    }

    func updateData(id: Int, type: HabitType, count: Int, total: Int, userID: Int? = nil, date: String) {
        let query = "UPDATE HABIT SET type = ?, count = ?, total = ?, userID = ?, setDate = ? WHERE id = ?"
        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 1, Int32(type.rawValue)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 2, Int32(count)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 3, Int32(total)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if let userID {
            if sqlite3_bind_int(stmt, 4, Int32(userID)) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
                return
            }
        } else {
            sqlite3_bind_null(stmt, 4)
        }

        if sqlite3_bind_text(stmt, 5, NSString(string: date).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 6, Int32(id)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
    }

    func deleteData(id: Int) {
        let query = "DELETE FROM HABIT WHERE id = ?"

        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 1, Int32(id)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
    }

    func deleteDataByUser(userID: Int) {
        let query = "DELETE FROM HABIT WHERE userID = ?"

        var stmt: OpaquePointer?
        defer {
            if stmt != nil {
                sqlite3_finalize(stmt)
            }
        }
        
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 1, Int32(userID)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
    }

    func dropTable() {
        var sql = "DROP TABLE if exists HABIT"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
    }
}

