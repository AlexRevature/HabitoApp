import SwiftUI

import SwiftUI

struct RecipeListView: View {
    var recipe: Recipe
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    recipeImage
                    timeAndCalories
                    recipeTitleAndRating
                    Divider().padding(.horizontal)
                    ingredientsSection
                    instructionsSection
                    customizationNote
                }
                .padding(.vertical)
            }
            .navigationTitle("Recipe Details")
           
        }
    }
    
    // MARK: - Subviews
    
    private var recipeImage: some View {
        Image(recipe.imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 250)
            .clipped()
            .cornerRadius(15)
            .padding(.horizontal)
    }
    
    private var timeAndCalories: some View {
        HStack {
            Label("\(recipe.calories) kcal", systemImage: "flame.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.green)
                .cornerRadius(10)
        }
        .font(.subheadline)
        .padding(.top, -20)
        .padding(.horizontal)
    }
    
    private var recipeTitleAndRating: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.horizontal)
        }
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients:")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(recipe.ingredients)
        }
        .padding(.horizontal)
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Instructions:")
                .font(.headline)
                .foregroundColor(.primary)
            Text(recipe.instructions)
        }
        .padding(.horizontal)
    }
    
    private var customizationNote: some View {
        Text("You can customize it with additional toppings or ingredients to suit your taste or calorie count!")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
    }
    
   
    
}
// Sample Preview
#Preview {
    let recipe = Recipe(id: 0, title: "testtile", ingredients: "test", instructions: "test", calories: "test", imageName: "spaghetti")
    RecipeListView(recipe: recipe)
}
