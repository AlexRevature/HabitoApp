import Foundation
import SQLite3

struct Recipe {
    let id: Int64
    let title: String
    let ingredients: String
    let instructions: String
    let calories : String
    let imageName : String
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
                instructions TEXT,
                calories TEXT,
                imageName TEXT
            );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error creating table: \(errmsg)")
        }
        addTestRecipes()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    func addRecipe(title: String, ingredients: String, instructions: String, calories: String, imageName: String) {
        let insertQuery = "INSERT INTO Recipe (title, ingredients, instructions, calories, imageName) VALUES (?, ?, ?, ?, ?);"
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
        
        if sqlite3_bind_text(stmt, 4, calories, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding calories: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_bind_text(stmt, 5, imageName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print( "Error binding imageName: \(errmsg)")
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
        let query = "SELECT id, title, ingredients, instructions, calories, imageName FROM Recipe;"
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
                  let instructionsCStr = sqlite3_column_text(stmt, 3),
                  let caloriesCStr = sqlite3_column_text(stmt, 4),
                  let imageNameCSTr = sqlite3_column_text(stmt, 5)
            else {
                continue
            }
            
            let title = String(cString: titleCStr)
            let ingredients = String(cString: ingredientsCStr)
            let instructions = String(cString: instructionsCStr)
            let calories = String(cString: caloriesCStr)
            let imageName = String(cString: imageNameCSTr)
            let recipe = Recipe(id: id, title: title, ingredients: ingredients, instructions: instructions, calories: calories, imageName: imageName)
            recipes.append(recipe)
        }
        
        sqlite3_finalize(stmt)
        return recipes
    }
    
    func addTestRecipes() {
            // Check if there are already any recipes in the database
            let existingRecipes = getRecipes()
            if existingRecipes.isEmpty {
                // Recipe 1: Spaghetti Bolognese
                addRecipe(
                    title: "Spaghetti Bolognese",
                    ingredients: """
                    - 400g spaghetti
                    - 2 tbsp olive oil
                    - 1 onion, diced
                    - 2 garlic cloves, minced
                    - 500g ground beef
                    - 800g canned tomatoes
                    - Salt, pepper, and basil to taste
                    """,
                    instructions: """
                    1. Cook spaghetti according to package instructions.
                    2. In a pan, heat olive oil and sauté the diced onion and garlic until soft.
                    3. Add the ground beef and cook until browned.
                    4. Stir in the canned tomatoes and season with salt, pepper, and basil.
                    5. Let simmer for 15 minutes and serve the sauce over the spaghetti.
                    """,
                    calories: "650 cal",
                    imageName: "mainscene"
                )
                
                // Recipe 2: Chicken Caesar Salad
                addRecipe(
                    title: "Chicken Caesar Salad",
                    ingredients: """
                    - 2 chicken breasts
                    - 1 head Romaine lettuce, chopped
                    - Caesar dressing
                    - Croutons
                    - Parmesan cheese, shaved
                    """,
                    instructions: """
                    1. Grill the chicken breasts until fully cooked and slice them thinly.
                    2. In a large bowl, toss the chopped Romaine lettuce with Caesar dressing.
                    3. Top the salad with the grilled chicken, croutons, and shaved Parmesan.
                    4. Serve immediately.
                    """,
                    calories: "400 cal",
                    imageName: "mainscene"
                )
                
                // Recipe 3: Chocolate Chip Cookies
                addRecipe(
                    title: "Chocolate Chip Cookies",
                    ingredients: """
                    - 1 cup butter, softened
                    - 1 cup white sugar
                    - 1 cup brown sugar
                    - 2 eggs
                    - 2 tsp vanilla extract
                    - 3 cups all-purpose flour
                    - 1 tsp baking soda
                    - 2 tsp hot water
                    - 0.5 tsp salt
                    - 2 cups chocolate chips
                    """,
                    instructions: """
                    1. Preheat your oven to 350°F (175°C).
                    2. Cream together the butter, white sugar, and brown sugar until smooth.
                    3. Beat in the eggs one at a time, then stir in the vanilla.
                    4. Dissolve the baking soda in hot water and add to the mixture.
                    5. Stir in the flour, salt, and chocolate chips.
                    6. Drop by spoonfuls onto an ungreased baking sheet.
                    7. Bake for about 10 minutes, or until edges are nicely browned.
                    """,
                    calories: "150 cal",
                    imageName: "mainscene"
                )
            }
    }
}
