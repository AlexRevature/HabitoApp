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

    private init(manager: DBManager) {
        self.manager = manager
        self.db = manager.db
        createTable()
    }

    func createTable() {
        var sql = "DROP TABLE if exists HABIT"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }

        sql = """
            CREATE TABLE if not exists HABIT
            id INTEGER PRIMARY KEY,
            title TEXT,
            message TEXT,
            image BLOB,
            backImage BLOB,
            trackImage BLOB,
            count INTEGER,
            total INTEGER,
            unit TEXT,
            userID INTEGER,
            setDate TEXT,
            FOREIGN KEY(userID) REFERENCES USER(userID)
            )
            """
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
    }

    func insertData(title: String, message: String, image: Data, backImage: Data, trackImage: Data, count: Int, total: Int, unit: String, userID: Int, date: String) -> Int? {
        var stmt: OpaquePointer?
        let query = "INSERT INTO HABIT(title,message,image,backImage,trackImage,count,total,unit,userID,setDate) VALUES(?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 1, title, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 2, message, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        var rawData = image as NSData
        if sqlite3_bind_blob(stmt, 3, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        rawData = backImage as NSData
        if sqlite3_bind_blob(stmt, 4, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        rawData = trackImage as NSData
        if sqlite3_bind_blob(stmt, 5, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 6, Int32(count)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 7, Int32(total)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 8, unit, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_int(stmt, 9, Int32(userID)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_bind_text(stmt, 10, date, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        print("Insert Done")
        return Int(sqlite3_last_insert_rowid(stmt))

    }

    func fetchData() -> [Habit]? {

        var habitList = [Habit]()
        let query = "SELECT * FROM HABIT"
        var stmt: OpaquePointer?

        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let message = String(cString: sqlite3_column_text(stmt, 2))

            let imageLength = sqlite3_column_bytes(stmt, 3)
            let rawImage = sqlite3_column_blob(stmt, 3)
            let image = Data(bytes: rawImage!, count: Int(imageLength))

            let backLength = sqlite3_column_bytes(stmt, 4)
            let rawBackImage = sqlite3_column_blob(stmt, 4)
            let backImage = Data(bytes: rawBackImage!, count: Int(backLength))

            let trackLength = sqlite3_column_bytes(stmt, 5)
            let rawTrackImage = sqlite3_column_blob(stmt, 5)
            let trackImage = Data(bytes: rawTrackImage!, count: Int(trackLength))

            let count = Int(sqlite3_column_int(stmt, 6))
            let total = Int(sqlite3_column_int(stmt, 7))
            let unit = String(cString: sqlite3_column_text(stmt, 8))

            let userID = Int(sqlite3_column_int(stmt, 9))
            let date = String(cString: sqlite3_column_text(stmt, 10))

            habitList.append(Habit(id: id, title: title, message: message, image: image, backImage: backImage, trackImage: trackImage, count: count, total: total, unit: unit, userID: userID, date: date))
        }

        return habitList
    }

    func fetchDataByUserDate(userID: Int, date: String) -> [Habit]? {
        var habitList = [Habit]()
        let query = "SELECT * FROM HABIT WHERE userID = ? AND setDate = ?"
        var stmt: OpaquePointer?

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

        if sqlite3_bind_text(stmt, 2, date, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return nil
        }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let message = String(cString: sqlite3_column_text(stmt, 2))

            let imageLength = sqlite3_column_bytes(stmt, 3)
            let rawImage = sqlite3_column_blob(stmt, 3)
            let image = Data(bytes: rawImage!, count: Int(imageLength))

            let backLength = sqlite3_column_bytes(stmt, 4)
            let rawBackImage = sqlite3_column_blob(stmt, 4)
            let backImage = Data(bytes: rawBackImage!, count: Int(backLength))

            let trackLength = sqlite3_column_bytes(stmt, 5)
            let rawTrackImage = sqlite3_column_blob(stmt, 5)
            let trackImage = Data(bytes: rawTrackImage!, count: Int(trackLength))

            let count = Int(sqlite3_column_int(stmt, 6))
            let total = Int(sqlite3_column_int(stmt, 7))
            let unit = String(cString: sqlite3_column_text(stmt, 8))

            let userID = Int(sqlite3_column_int(stmt, 9))
            let date = String(cString: sqlite3_column_text(stmt, 10))

            habitList.append(Habit(id: id, title: title, message: message, image: image, backImage: backImage, trackImage: trackImage, count: count, total: total, unit: unit, userID: userID, date: date))
        }

        return habitList
    }

    func fetchDataById(id: Int) -> Habit? {
        let query = "SELECT * FROM HABIT WHERE id = ? LIMIT 1"
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
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let message = String(cString: sqlite3_column_text(stmt, 2))

            let imageLength = sqlite3_column_bytes(stmt, 3)
            let rawImage = sqlite3_column_blob(stmt, 3)
            let image = Data(bytes: rawImage!, count: Int(imageLength))

            let backLength = sqlite3_column_bytes(stmt, 4)
            let rawBackImage = sqlite3_column_blob(stmt, 4)
            let backImage = Data(bytes: rawBackImage!, count: Int(backLength))

            let trackLength = sqlite3_column_bytes(stmt, 5)
            let rawTrackImage = sqlite3_column_blob(stmt, 5)
            let trackImage = Data(bytes: rawTrackImage!, count: Int(trackLength))

            let count = Int(sqlite3_column_int(stmt, 6))
            let total = Int(sqlite3_column_int(stmt, 7))
            let unit = String(cString: sqlite3_column_text(stmt, 8))

            let userID = Int(sqlite3_column_int(stmt, 9))
            let date = String(cString: sqlite3_column_text(stmt, 10))

            return Habit(id: id, title: title, message: message, image: image, backImage: backImage, trackImage: trackImage, count: count, total: total, unit: unit, userID: userID, date: date)
        }

        return nil
    }

    func updateData(id: Int, title: String, message: String, image: Data, backImage: Data, trackImage: Data, count: Int, total: Int, unit: String, userID: Int, date: String) {
        let query = "UPDATE USER SET title = ?, message = ?, image = ?, backImage = ?, trackImage = ?, count = ?, total = ?, unit = ?, userID = ?, date = ? WHERE id = ?"
        var stmt: OpaquePointer?
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 1, title, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 2, message, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        var rawData = image as NSData
        if sqlite3_bind_blob(stmt, 3, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        rawData = backImage as NSData
        if sqlite3_bind_blob(stmt, 4, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        rawData = trackImage as NSData
        if sqlite3_bind_blob(stmt, 5, rawData.bytes, Int32(rawData.length), nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 6, Int32(count)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 7, Int32(total)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 8, unit, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 9, Int32(userID)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_text(stmt, 10, date, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_bind_int(stmt, 11, Int32(id)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
        print("Update Done")
    }

    func deleteData(id: Int) {
        let query = "DELETE FROM HABIT WHERE id = ?"

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
        print("Delete Done")
    }
}

