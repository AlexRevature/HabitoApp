//
//  UserManager.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import Foundation
import SQLite3

class UserManager {

    let manager: DBManager
    let db: OpaquePointer?
    static let shared = UserManager(manager: DBManager.shared)

    private init(manager: DBManager) {
        self.manager = manager
        self.db = manager.db
        createTable()
    }

    func createTable() {
        var sql = "DROP TABLE if exists USER"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        sql = """
            CREATE TABLE if not exists USER (
                id INTEGER PRIMARY KEY,
                name TEXT,
                email TEXT UNIQUE,
                phone TEXT,
                image BLOB NULL
            );
            """
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
    }

    func insertData(name: String, email: String, phone: String, image: Data? = nil) -> Int? {
        var stmt: OpaquePointer?
        let query = "INSERT INTO USER(name,email,phone,image) VALUES(?,?,?,?);"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 1, NSString(string: name).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 2, NSString(string: email).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 3, NSString(string: phone).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if let image {
            let rawData = image as NSData
            if sqlite3_bind_blob(stmt, 4, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
                return nil
            }
        } else {
            sqlite3_bind_null(stmt, 4)
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        sqlite3_finalize(stmt)
        return Int(sqlite3_last_insert_rowid(db))

    }

    func fetchData() -> [User]? {

        var userList = [User]()
        let query = "SELECT id,name,email,phone,image FROM USER;"
        var stmt: OpaquePointer?

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let email = String(cString: sqlite3_column_text(stmt, 2))
            let phone = String(cString: sqlite3_column_text(stmt, 3))

            let dataCount = sqlite3_column_bytes(stmt, 4)
            let rawImage = sqlite3_column_blob(stmt, 4)

            let image: Data? = if let rawImage {
                Data(bytes: rawImage, count: Int(dataCount))
            } else {
                nil
            }

            userList.append(User(id: id, name: name, email: email, phone: phone, image: image))
        }

        sqlite3_finalize(stmt)
        return userList
    }

    func fetchDataById(id: Int) -> User? {
        let query = "SELECT id,name,email,phone,image FROM USER WHERE id = ?;"
        var stmt: OpaquePointer?

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
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let email = String(cString: sqlite3_column_text(stmt, 2))
            let phone = String(cString: sqlite3_column_text(stmt, 3))

            let dataCount = sqlite3_column_bytes(stmt, 4)
            let rawImage = sqlite3_column_blob(stmt, 4)

            let image: Data? = if let rawImage {
                Data(bytes: rawImage, count: Int(dataCount))
            } else {
                nil
            }

            return User(id: id, name: name, email: email, phone: phone, image: image)
        }

        return nil
    }

    func fetchDataByEmail(email: String) -> User? {
        let query = "SELECT id,name,email,phone,image FROM USER WHERE email = ?;"
        var stmt: OpaquePointer?

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 1, NSString(string: email).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let email = String(cString: sqlite3_column_text(stmt, 2))
            let phone = String(cString: sqlite3_column_text(stmt, 3))

            let dataCount = sqlite3_column_bytes(stmt, 4)
            let rawImage = sqlite3_column_blob(stmt, 4)

            let image: Data? = if let rawImage {
                Data(bytes: rawImage, count: Int(dataCount))
            } else {
                nil
            }

            return User(id: id, name: name, email: email, phone: phone, image: image)
        }

        return nil
    }

    func fetchID(email: String) -> Int? {
        let query = "SELECT id FROM USER WHERE email = ?;"
        var stmt: OpaquePointer?

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 1, NSString(string: email).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            return Int(id)
        }

        return nil
    }

    func updateData(id: Int, name: String, email: String, phone: String, image: Data) {
        let query = "UPDATE USER SET name = ?, email = ?, phone = ?, image = ? WHERE id = ?"
        var stmt: OpaquePointer?
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 1, NSString(string: name).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 2, NSString(string: email).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 3, NSString(string: phone).utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        let rawData = image as NSData
        if sqlite3_bind_blob(stmt, 4, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 5, Int32(id)) != SQLITE_OK {
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
        let query = "DELETE FROM USER WHERE id = ?"

        var stmt: OpaquePointer?
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
}
