import SwiftUI

struct RecipeMainView: View {
    var recipes: [Recipe] = RecipeModel.shared.getRecipes()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                VStack(alignment: .leading) {
                    Text("Healthy Recipes")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    Text("Meal Plans")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .padding(.top, 5)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeListView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea(.bottom)
                
                // Floating add button overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddButton(action: {
                            // Action for add button
                        })
                        .padding(.bottom, 20)
                        .padding(.trailing, 20)
                    }
                }
            }
        }
    }
}

// Extracted view for a recipe card
struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = UIImage(named: recipe.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Text(recipe.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding(.top, 5)
            
            Text("\(recipe.calories) kcal")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 10)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 2)
    }
}

// Extracted view for the floating add button
struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    RecipeMainView()
}
