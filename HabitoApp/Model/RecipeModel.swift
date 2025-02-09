import Foundation
import SQLite3

struct Recipe {
    let id: Int64
    let title: String
    let ingredients: String
    let instructions: String
}

class RecipeModel {
    static let shared = RecipeModel()
    
    private var db: OpaquePointer?
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
   
    private init() {
      
        let fileURL: URL
        do {
            fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask,
                     appropriateFor: nil, create: true)
                .appendingPathComponent("HabitoApp.sqlite")
        } catch {
            fatalError("Unable to locate documents directory: \(error)")
        }
        
      
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error opening database: \(errmsg)")
        }
        
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Recipe (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                ingredients TEXT,
                instructions TEXT
            );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error creating table: \(errmsg)")
        }
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    func addRecipe(title: String, ingredients: String, instructions: String) {
        let insertQuery = "INSERT INTO Recipe (title, ingredients, instructions) VALUES (?, ?, ?);"
        var stmt: OpaquePointer?
        
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding title: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_bind_text(stmt, 2, ingredients, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding ingredients: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_bind_text(stmt, 3, instructions, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding instructions: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error inserting recipe: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    func getRecipes() -> [Recipe] {
        let query = "SELECT id, title, ingredients, instructions FROM Recipe;"
        var stmt: OpaquePointer?
        var recipes = [Recipe]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing select: \(errmsg)")
            return []
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            
            guard let titleCStr = sqlite3_column_text(stmt, 1),
                  let ingredientsCStr = sqlite3_column_text(stmt, 2),
                  let instructionsCStr = sqlite3_column_text(stmt, 3) else {
                continue
            }
            
            let title = String(cString: titleCStr)
            let ingredients = String(cString: ingredientsCStr)
            let instructions = String(cString: instructionsCStr)
            
            let recipe = Recipe(id: id, title: title, ingredients: ingredients, instructions: instructions)
            recipes.append(recipe)
        }
        
        sqlite3_finalize(stmt)
        return recipes
    }
}
