//
//  RecipeMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct RecipeMainView: View {
    var recipes = RecipeModel.shared.getRecipes()
    var body: some View {
        List(recipes, id: \.id){
                recipe in NavigationLink(destination: RecipeListView(recipe: recipe)){
                    VStack{
                        Image(uiImage: UIImage(named: "mainscene")!).clipShape(RoundedRectangle(cornerRadius: 20))
                        Text(recipe.title).foregroundColor(.primary).font(.largeTitle)
                        Text(recipe.calories).foregroundColor(.primary)
                    }
                }
            }
        }
    }


#Preview {
    NavigationStack{
        RecipeMainView()
    }
}
