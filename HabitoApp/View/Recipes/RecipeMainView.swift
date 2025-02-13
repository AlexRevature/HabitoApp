import SwiftUI

struct RecipeMainView: View {
    var recipes: [Recipe] = RecipeModel.shared.getRecipes()
    
    var body: some View {
        NavigationStack {
          
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
                       
                            ForEach(recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeListView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                            }
                        
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea(.bottom)
                .toolbar{
                    bottomToolbar
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
private var bottomToolbar: some ToolbarContent {
    ToolbarItem(placement: .bottomBar) {
        HStack(spacing: 40) {
            NavigationLink(destination: ContentView()) {
                Image(systemName: "house.fill")
            }
            NavigationLink(destination: ProfileMainView()) {
                Image(systemName: "person.fill")
            }
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.green)
            }
            NavigationLink(destination: HabitMainView()) {
                Image(systemName: "heart.fill")
            }
        }
        .font(.title2)
        .foregroundColor(.gray)
    }
}


#Preview {
    RecipeMainView()
}
