import Foundation
import SQLite3

struct Challenge {
    let id: Int64
    let title: String
    let message: String
    let imageName: String
    let backImageName: String
    let trackImageName: String
    let count: Int
    let total: Int
    let unit: String
    let date: String    // New field to store month and day (e.g., "MM-dd")
}

class ChallengeModel {
    static let shared = ChallengeModel()
    
    private var db: OpaquePointer?
    // This value tells SQLite to make a copy of the data passed in.
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private init() {
        // Get the database file URL from the documents directory.
        let fileURL: URL
        do {
            fileURL = try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("HabitoApp.sqlite")
        } catch {
            fatalError("Unable to locate documents directory: \(error)")
        }
        
        // Open the SQLite database.
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error opening database: \(errmsg)")
        }
        
        // Create the Challenge table if it doesn't exist.
        // Added a new "date" column to store the month and day.
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Challenge (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            message TEXT,
            imageName TEXT,
            backImageName TEXT,
            trackImageName TEXT,
            count INTEGER,
            total INTEGER,
            unit TEXT,
            date TEXT
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error creating Challenge table: \(errmsg)")
        }
        
        // Optionally add test challenges if none exist.
        addTestChallenges()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    /// Inserts a new challenge into the database.
    func addChallenge(title: String,
                      message: String,
                      imageName: String,
                      backImageName: String,
                      trackImageName: String,
                      count: Int,
                      total: Int,
                      unit: String,
                      date: String) {   // New date parameter
        let insertQuery = """
        INSERT INTO Challenge (title, message, imageName, backImageName, trackImageName, count, total, unit, date)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        var stmt: OpaquePointer?
        
        // Prepare the SQL statement.
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        // Bind the text values.
        if sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK ||
           sqlite3_bind_text(stmt, 2, message, -1, SQLITE_TRANSIENT) != SQLITE_OK ||
           sqlite3_bind_text(stmt, 3, imageName, -1, SQLITE_TRANSIENT) != SQLITE_OK ||
           sqlite3_bind_text(stmt, 4, backImageName, -1, SQLITE_TRANSIENT) != SQLITE_OK ||
           sqlite3_bind_text(stmt, 5, trackImageName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding text values: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        // Bind the integer values.
        if sqlite3_bind_int(stmt, 6, Int32(count)) != SQLITE_OK ||
           sqlite3_bind_int(stmt, 7, Int32(total)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding integer values: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        // Bind the remaining text values.
        if sqlite3_bind_text(stmt, 8, unit, -1, SQLITE_TRANSIENT) != SQLITE_OK ||
           sqlite3_bind_text(stmt, 9, date, -1, SQLITE_TRANSIENT) != SQLITE_OK { // Binding the date
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding unit/date: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        // Execute the statement.
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error inserting challenge: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func deleteChallenge(byId id: Int64) {
        let deleteQuery = "DELETE FROM Challenge WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing delete: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int64(stmt, 1, id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding id: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error deleting challenge: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }

    
    /// Retrieves all challenges from the database.
    func getChallenges() -> [Challenge] {
        let query = """
        SELECT id, title, message, imageName, backImageName, trackImageName, count, total, unit, date
        FROM Challenge;
        """
        var stmt: OpaquePointer?
        var challenges = [Challenge]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing select: \(errmsg)")
            return []
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            
            guard let titleCStr = sqlite3_column_text(stmt, 1),
                  let messageCStr = sqlite3_column_text(stmt, 2),
                  let imageNameCStr = sqlite3_column_text(stmt, 3),
                  let backImageNameCStr = sqlite3_column_text(stmt, 4),
                  let trackImageNameCStr = sqlite3_column_text(stmt, 5),
                  let unitCStr = sqlite3_column_text(stmt, 8),
                  let dateCStr = sqlite3_column_text(stmt, 9)  // Retrieve the date field
            else {
                continue
            }
            
            let title = String(cString: titleCStr)
            let message = String(cString: messageCStr)
            let imageName = String(cString: imageNameCStr)
            let backImageName = String(cString: backImageNameCStr)
            let trackImageName = String(cString: trackImageNameCStr)
            let count = Int(sqlite3_column_int(stmt, 6))
            let total = Int(sqlite3_column_int(stmt, 7))
            let unit = String(cString: unitCStr)
            let date = String(cString: dateCStr)
            
            let challenge = Challenge(id: id,
                                      title: title,
                                      message: message,
                                      imageName: imageName,
                                      backImageName: backImageName,
                                      trackImageName: trackImageName,
                                      count: count,
                                      total: total,
                                      unit: unit,
                                      date: date)
            challenges.append(challenge)
        }
        
        sqlite3_finalize(stmt)
        return challenges
    }
    
    /// Adds sample challenge(s) to the database if none exist.
    func addTestChallenges() {
        let existingChallenges = getChallenges()
        if existingChallenges.isEmpty {
            addChallenge(
                title: "10K Steps Challenge",
                message: "Aim to complete 10,000 steps today to stay active!",
                imageName: "steps",             // Name of the image asset
                backImageName: "challengeBack",  // Name of the background asset
                trackImageName: "figure.walk",   // Name of the track asset (can be a system image name)
                count: 0,
                total: 10000,
                unit: "steps",
                date: "01-01"                   // Example date in "MM-dd" format
            )
            
            // Add additional test challenges here if needed.
        }
    }
}
