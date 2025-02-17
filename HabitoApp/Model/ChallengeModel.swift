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
    let startDate: String   // New: start date in "yyyy-MM-dd" format
    let endDate: String     // New: end date in "yyyy-MM-dd" format
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
        // Modified schema to support a date range.
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
            startDate TEXT,
            endDate TEXT
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
                      startDate: String,  // New parameter for start date
                      endDate: String) {   // New parameter for end date
        let insertQuery = """
        INSERT INTO Challenge (title, message, imageName, backImageName, trackImageName, count, total, unit, startDate, endDate)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
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
           sqlite3_bind_text(stmt, 9, startDate, -1, SQLITE_TRANSIENT) != SQLITE_OK ||  // Bind startDate
           sqlite3_bind_text(stmt, 10, endDate, -1, SQLITE_TRANSIENT) != SQLITE_OK {   // Bind endDate
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding unit/dates: \(errmsg)")
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
        SELECT id, title, message, imageName, backImageName, trackImageName, count, total, unit, startDate, endDate
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
                  let startDateCStr = sqlite3_column_text(stmt, 9),
                  let endDateCStr = sqlite3_column_text(stmt, 10)
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
            let startDate = String(cString: startDateCStr)
            let endDate = String(cString: endDateCStr)
            
            let challenge = Challenge(id: id,
                                      title: title,
                                      message: message,
                                      imageName: imageName,
                                      backImageName: backImageName,
                                      trackImageName: trackImageName,
                                      count: count,
                                      total: total,
                                      unit: unit,
                                      startDate: startDate,
                                      endDate: endDate)
            challenges.append(challenge)
        }
        
        sqlite3_finalize(stmt)
        return challenges
    }
    
    /// Adds sample challenge(s) to the database if none exist.
    func addTestChallenges() {
        let existingChallenges = getChallenges()
        if existingChallenges.isEmpty {
            // For a single-day challenge, startDate and endDate will be the same.
            addChallenge(
                title: "10K Steps Challenge",
                message: "Aim to complete 10,000 steps today to stay active!",
                imageName: "steps",
                backImageName: "challengeBack",
                trackImageName: "figure.walk",
                count: 0,
                total: 10000,
                unit: "steps",
                startDate: "2025-01-01",   // Example start date in "yyyy-MM-dd" format
                endDate: "2025-01-01"      // Same as start date for a single-day challenge
            )
            
            // Additional test challenges can be added here.
        }
    }
}
