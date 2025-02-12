//
//  RecipeListView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct RecipeListView: View {
    var recipe: Recipe
    var body: some View {
        VStack {
            Text(recipe.title).font(.largeTitle).fontWeight(.bold).foregroundColor(.primary)
            Text(recipe.ingredients).foregroundColor(.primary)
            Text(recipe.instructions).foregroundColor(.primary)
            
        }.padding()
    }
}

#Preview {
    let recipe = Recipe(id: 0, title: "Test", ingredients: "test", instructions: "test", calories: "0")
    RecipeListView(recipe: recipe)
}
