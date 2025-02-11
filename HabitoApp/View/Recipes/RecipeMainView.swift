//
//  RecipeMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct RecipeMainView: View {

    var image: UIImage
    var recipes = RecipeModel.shared.getRecipes()
    var body: some View {
        VStack {
            HStack {
                Text("Healthy Eating")
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 120, alignment: .leading)
                Spacer()
            }
            .padding(.init(top: 50, leading: 25, bottom: 50, trailing: 25))
            .background {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.9)
                    .background(.green)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            List(recipes, id: \.id){
                recipe in NavigationLink(destination: RecipeListView(recipe: recipe)){
                    VStack{
                        Image(uiImage: UIImage(named: "mainscene")!)
                        Text(recipe.title).foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeMainView(image: UIImage(named: "sample")!)
}
