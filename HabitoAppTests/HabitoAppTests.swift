import XCTest
@testable import HabitoApp

final class RecipeLoadingTests: XCTestCase {
    
   
    // clear the database (or use an in-memory database) in setUpWithError().
    override func setUpWithError() throws {
        // Optionally, reset the database here if needed.
        // For example, delete the "HabitoApp.sqlite" file from the documents directory
        // to force a clean start for each test.
    }
    
    override func tearDownWithError() throws {
        // Cleanup if necessary.
    }
    
    // Test that the initial recipes (added via addTestRecipes) are loaded.
    func testInitialRecipesLoaded() throws {
        let recipes = RecipeModel.shared.getRecipes()
        XCTAssertFalse(recipes.isEmpty, "The recipes list should not be empty after initialization.")
        
        let expectedTitles = ["Spaghetti Bolognese", "Chicken Caesar Salad", "Chocolate Chip Cookies"]
        for title in expectedTitles {
            XCTAssertTrue(recipes.contains(where: { $0.title == title }), "Expected recipe \(title) is missing.")
        }
    }
    
    // Test that adding a new recipe increases the count and the recipe can be found with correct details.
    func testAddNewRecipe() throws {
        let initialRecipes = RecipeModel.shared.getRecipes()
        let initialCount = initialRecipes.count
        
        RecipeModel.shared.addRecipe(
            title: "Test Recipe",
            ingredients: "Ingredient1, Ingredient2",
            instructions: "Step 1, Step 2",
            calories: "200",
            imageName: "testImage"
        )
        
        let updatedRecipes = RecipeModel.shared.getRecipes()
        XCTAssertEqual(updatedRecipes.count, initialCount + 1, "Recipe count should increase by 1 after adding a new recipe.")
        
        if let newRecipe = updatedRecipes.first(where: { $0.title == "Test Recipe" }) {
            XCTAssertEqual(newRecipe.ingredients, "Ingredient1, Ingredient2", "Ingredients should match.")
            XCTAssertEqual(newRecipe.instructions, "Step 1, Step 2", "Instructions should match.")
            XCTAssertEqual(newRecipe.calories, "200", "Calories should match.")
            XCTAssertEqual(newRecipe.imageName, "testImage", "Image name should match.")
        } else {
            XCTFail("The newly added 'Test Recipe' was not found in the recipes list.")
        }
    }
    
    // Test that loading recipes multiple times gives consistent results.
    func testRecipeLoadConsistency() throws {
        let firstLoad = RecipeModel.shared.getRecipes()
        let secondLoad = RecipeModel.shared.getRecipes()
        
        XCTAssertEqual(firstLoad.count, secondLoad.count, "The number of recipes should be consistent across multiple loads.")
        
        for (recipe1, recipe2) in zip(firstLoad, secondLoad) {
            XCTAssertEqual(recipe1.id, recipe2.id, "Recipe IDs should be consistent.")
            XCTAssertEqual(recipe1.title, recipe2.title, "Recipe titles should be consistent.")
            XCTAssertEqual(recipe1.ingredients, recipe2.ingredients, "Recipe ingredients should be consistent.")
            XCTAssertEqual(recipe1.instructions, recipe2.instructions, "Recipe instructions should be consistent.")
            XCTAssertEqual(recipe1.calories, recipe2.calories, "Recipe calories should be consistent.")
            XCTAssertEqual(recipe1.imageName, recipe2.imageName, "Recipe image names should be consistent.")
        }
    }
}
