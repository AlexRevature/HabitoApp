//
//  GuideModel.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/16/25.
//

import Foundation
import SQLite3

struct Guide {
    let id: Int64
    let title: String
    let summary: String
    let content: String
    let imageName: String
}

class GuideModel {
    static let shared = GuideModel()
    
    private var db: OpaquePointer?
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private init() {
        // Locate the documents directory and create the database file
        let fileURL: URL
        do {
            fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask,
                     appropriateFor: nil, create: true)
                .appendingPathComponent("HabitoApp.sqlite")
        } catch {
            fatalError("Unable to locate documents directory: \(error)")
        }
        
        // Open (or create) the SQLite database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error opening database: \(errmsg)")
        }
        
        // Create the Guide table if it doesn't already exist
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Guide (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                summary TEXT,
                content TEXT,
                imageName TEXT
            );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            fatalError("Error creating table: \(errmsg)")
        }
        
        // Add some test guides (if none exist)
        addTestGuides()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    // MARK: - Add a new guide
    func addGuide(title: String, summary: String, content: String, imageName: String) {
        let insertQuery = "INSERT INTO Guide (title, summary, content, imageName) VALUES (?, ?, ?, ?);"
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
        
        if sqlite3_bind_text(stmt, 2, summary, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding summary: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_bind_text(stmt, 3, content, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding content: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_bind_text(stmt, 4, imageName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error binding imageName: \(errmsg)")
            sqlite3_finalize(stmt)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error inserting guide: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    // MARK: - Retrieve all guides
    func getGuides() -> [Guide] {
        let query = "SELECT id, title, summary, content, imageName FROM Guide;"
        var stmt: OpaquePointer?
        var guides = [Guide]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing select: \(errmsg)")
            return []
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            
            guard let titleCStr = sqlite3_column_text(stmt, 1),
                  let summaryCStr = sqlite3_column_text(stmt, 2),
                  let contentCStr = sqlite3_column_text(stmt, 3),
                  let imageNameCStr = sqlite3_column_text(stmt, 4)
            else {
                continue
            }
            
            let title = String(cString: titleCStr)
            let summary = String(cString: summaryCStr)
            let content = String(cString: contentCStr)
            let imageName = String(cString: imageNameCStr)
            let guide = Guide(id: id, title: title, summary: summary, content: content, imageName: imageName)
            guides.append(guide)
        }
        
        sqlite3_finalize(stmt)
        return guides
    }
    
    // MARK: - Add test guides with longer article content
    func addTestGuides() {
        // Only add test guides if there are no guides in the database
        let existingGuides = getGuides()
        if existingGuides.isEmpty {
            // Guide 1: Nutrition Basics
            addGuide(
                title: "Nutrition Basics",
                summary: "An introduction to balanced nutrition.",
                content: """
                Balanced nutrition is essential for a healthy lifestyle. The foundations of nutrition involve understanding macronutrients like proteins, carbohydrates, and fats as well as micronutrients such as vitamins and minerals. In this article, we explore the role each nutrient plays in our bodies and how a balanced diet contributes to overall well-being.

                It is important to note that no single food or nutrient can provide all the essential components your body needs. Instead, a diverse diet that includes a variety of fruits, vegetables, whole grains, lean proteins, and healthy fats is key to optimal health. Learning portion control, reading nutritional labels, and being mindful of dietary choices are fundamental steps toward healthier eating habits.

                Research shows that diets rich in whole foods and low in processed items can significantly reduce the risk of chronic diseases such as obesity, type 2 diabetes, and cardiovascular conditions. By incorporating these insights into your daily routine, you can enjoy more energy, improved mood, and an overall better quality of life.
                """,
                imageName: "nutrition"
            )
            
            // Guide 2: Benefits of Regular Exercise
            addGuide(
                title: "Benefits of Regular Exercise",
                summary: "Understanding the physical and mental benefits of staying active.",
                content: """
                Exercise is not just about losing weight or building muscle; it plays a crucial role in enhancing mental clarity, emotional stability, and overall quality of life. Regular physical activity can improve cardiovascular health, strengthen bones and muscles, and promote better sleep patterns. In this article, we delve into the extensive benefits of incorporating exercise into your routine.

                Physical activity releases endorphins—natural chemicals in the brain that help to elevate mood and reduce stress. Activities such as walking, cycling, or swimming not only build endurance and strength but also foster mental well-being. As you progress in your fitness journey, you may notice increased energy levels, sharper focus, and a more positive outlook on life.

                Whether you are just starting or are already an active individual, understanding the comprehensive benefits of exercise can motivate you to make fitness a regular part of your lifestyle.
                """,
                imageName: "exercise"
            )
            
            // Guide 4: The Importance of Sleep
            addGuide(
                title: "The Importance of Sleep",
                summary: "Understanding how quality sleep contributes to health and well-being.",
                content: """
                Sleep is a fundamental pillar of health that is often overlooked in our busy lives. This article examines the critical role that sleep plays in physical restoration, mental clarity, and overall well-being. During sleep, your body undergoes essential repair processes such as tissue regeneration, muscle growth, and memory consolidation.

                Quality sleep is essential for maintaining a strong immune system, regulating hormones, and supporting cognitive functions. Inadequate sleep has been linked to a range of health issues including obesity, diabetes, and cardiovascular disease. By prioritizing sleep, you not only improve your physical health but also enhance your mood and overall quality of life.

                This guide offers practical advice on how to improve your sleep hygiene, such as maintaining a consistent bedtime routine, creating a comfortable sleep environment, and reducing screen time before bed. Embracing these practices can lead to more restorative sleep and a healthier, more energetic life.
                """,
                imageName: "sleep"
            )
        }
    }
}
