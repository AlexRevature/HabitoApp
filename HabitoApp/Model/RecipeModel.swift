//
//  RecipeModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation
import SwiftUICore
import CoreData

class RecipeModel{
    @Environment(\.managedObjectContext) private var viewContext
    
    init() {
    }
    
    deinit {
    }
    
    let singleton = RecipeModel()
    
    func addRecipe(ingredients: String, instructions: String){
        let toAdd = Recipe(context: viewContext)
        toAdd.ingredients = ingredients
        toAdd.instructions = instructions
        do {
            try viewContext.save()
        }
        catch {
            print("Error adding recipe: \(error)")
        }
    }
    func getRecipes() -> [Recipe] {
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        var toReturn : [Recipe] = []
        do{
            toReturn = try viewContext.fetch(request)
        }
        catch {
            print("Error fetching recipes: \(error)")
            return []
        }
        return toReturn
    }
}
