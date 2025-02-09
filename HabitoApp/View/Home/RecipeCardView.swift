import SwiftUI

// MARK: - Identifiable Models for Ingredients and Steps

struct Ingredient: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct RecipeStep: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct RecipeCardView: View {
    var image: UIImage
    
    // MARK: - Main View State
    @State private var showingAddRecipe = false
    @State private var recipes: [Recipe] = []
    
    // MARK: - Structured Add Recipe Form State
    @State private var title: String = "" // Add state for recipe title
    @State private var ingredients: [Ingredient] = [Ingredient(text: "")]
    @State private var steps: [RecipeStep] = [RecipeStep(text: "")]
    
    var body: some View {
        VStack {
            // MARK: - Card View at the Top
            VStack {
                HStack {
                    Text("Healthy Eating")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: 120, alignment: .leading)
                    Spacer()
                }
                .padding(.init(top: 50, leading: 25, bottom: 50, trailing: 25))
                .background {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.9)
                        .background(Color.green)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            
            // MARK: - List of Available Recipes
            List(recipes, id: \.id) { recipe in
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)  // Display the recipe title
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(recipe.ingredients)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(recipe.instructions)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Recipes")
        .toolbar {
            // "Add Recipe" button in the navigation bar
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddRecipe = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            recipes = RecipeModel.shared.getRecipes()
        }
        // MARK: - Sheet for Adding a New Recipe
        .sheet(isPresented: $showingAddRecipe, onDismiss: {
            recipes = RecipeModel.shared.getRecipes()
        }) {
            NavigationView {
                Form {
                    // MARK: Title Section
                    Section(header: Text("Title")) {
                        TextField("Recipe Title", text: $title)
                    }
                    
                    // MARK: Ingredients Section
                    Section(header: Text("Ingredients")) {
                        ForEach($ingredients) { $ingredient in
                            let index = ingredients.firstIndex(where: { $0.id == $ingredient.wrappedValue.id }) ?? 0
                            TextField("Ingredient \(index + 1)", text: $ingredient.text)
                        }
                        Button(action: {
                            ingredients.append(Ingredient(text: ""))
                        }) {
                            Label("Add Ingredient", systemImage: "plus.circle")
                        }
                    }
                    
                    // MARK: Steps Section
                    Section(header: Text("Steps")) {
                        ForEach($steps) { $step in
                            let index = steps.firstIndex(where: { $0.id == $step.wrappedValue.id }) ?? 0
                            TextField("Step \(index + 1)", text: $step.text)
                        }
                        Button(action: {
                            steps.append(RecipeStep(text: ""))
                        }) {
                            Label("Add Step", systemImage: "plus.circle")
                        }
                    }
                }
                .navigationTitle("New Recipe")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddRecipe = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let joinedIngredients = ingredients
                                .map { $0.text }
                                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                                .joined(separator: "\n")
                            
                            let joinedSteps = steps
                                .map { $0.text }
                                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                                .joined(separator: "\n")
                            
                            RecipeModel.shared.addRecipe(title: title, ingredients: joinedIngredients, instructions: joinedSteps)
                            
                            showingAddRecipe = false
                            recipes = RecipeModel.shared.getRecipes()
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                            ingredients.allSatisfy { $0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ||
                            steps.allSatisfy { $0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                        )
                    }
                }
                .onDisappear {
                    clearForm()
                }
            }
        }
    }
    
    /// Resets the add recipe form to its initial state.
    private func clearForm() {
        title = ""
        ingredients = [Ingredient(text: "")]
        steps = [RecipeStep(text: "")]
    }
}

#Preview {
    NavigationView {
        RecipeCardView(image: UIImage(named: "sample")!)
    }
}
