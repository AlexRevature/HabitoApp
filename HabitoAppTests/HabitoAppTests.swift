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
    
    final class ChallengeLoadingTests: XCTestCase {
        
        override func setUpWithError() throws {
            // Optionally, reset or clear the database state if necessary.
        }
        
        override func tearDownWithError() throws {
            // Cleanup after tests if needed.
        }
        
        // Test that the initial test challenge for user 1 is loaded.
        func testInitialChallengesLoaded() throws {
            // addTestChallenges in ChallengeModel creates a "10K Steps Challenge" for user id 1.
            let challenges = ChallengeModel.shared.getChallenges(forUser: 1)
            XCTAssertFalse(challenges.isEmpty, "The challenges list should not be empty after initialization.")
            XCTAssertEqual(challenges.first?.title, "10K Steps Challenge", "Expected test challenge '10K Steps Challenge' is missing.")
        }
        
        // Test that getChallenges(for:) in the view model correctly filters challenges for a given date.
        @MainActor func testGetChallengesForDate() throws {
            let viewModel = ChallengeViewModel()
            viewModel.userId = 1
            
            // Using the test challenge's date range: startDate and endDate are "2025-01-01".
            let dateComponents = DateComponents(year: 2025, month: 1, day: 1)
            guard let testDate = Calendar.current.date(from: dateComponents) else {
                XCTFail("Could not create test date from components.")
                return
            }
            
            let challenges = viewModel.getChallenges(for: testDate)
            XCTAssertFalse(challenges.isEmpty, "Challenges should be loaded for the test date.")
            XCTAssertEqual(challenges.first?.title, "10K Steps Challenge", "Test challenge should be loaded for the given date.")
        }
        
        // Test that oldestChallenge(userID:) returns the expected challenge.
        @MainActor func testOldestChallenge() throws {
            let viewModel = ChallengeViewModel()
            let challenge = viewModel.oldestChallenge(userID: 1)
            XCTAssertNotNil(challenge, "Oldest challenge should not be nil for user id 1.")
            XCTAssertEqual(challenge?.title, "10K Steps Challenge", "The oldest challenge should be '10K Steps Challenge'.")
        }
        
        // Test that getChallenges(for:) returns an empty array when no user is set.
        @MainActor func testGetChallengesWithNoUser() throws {
            let viewModel = ChallengeViewModel()
            viewModel.userId = nil
            
            let dateComponents = DateComponents(year: 2025, month: 1, day: 1)
            guard let testDate = Calendar.current.date(from: dateComponents) else {
                XCTFail("Could not create test date from components.")
                return
            }
            
            let challenges = viewModel.getChallenges(for: testDate)
            XCTAssertTrue(challenges.isEmpty, "Challenges should be empty if userId is not set.")
        }
        
        // Test the rotation logic when multiple challenges are available.
        @MainActor func testChallengeRotation() throws {
            // Use a dedicated user id for this test.
            let testUserId = 2
            
            // Clean up any existing challenges for testUserId.
            let existingChallenges = ChallengeModel.shared.getChallenges(forUser: testUserId)
            for challenge in existingChallenges {
                ChallengeModel.shared.deleteChallenge(byId: challenge.id)
            }
            
            // Add two distinct challenges for user id 2.
            ChallengeModel.shared.addChallenge(
                title: "Challenge A",
                message: "Message A",
                imageName: "imageA",
                backImageName: "backA",
                trackImageName: "trackA",
                count: 0,
                total: 10,
                unit: "unit",
                startDate: "2025-01-01",
                endDate: "2025-01-01",
                userId: testUserId
            )
            
            ChallengeModel.shared.addChallenge(
                title: "Challenge B",
                message: "Message B",
                imageName: "imageB",
                backImageName: "backB",
                trackImageName: "trackB",
                count: 0,
                total: 20,
                unit: "unit",
                startDate: "2025-01-01",
                endDate: "2025-01-01",
                userId: testUserId
            )
            
            // Use a date with day component = 3.
            // For two challenges, the rotation index is: 3 % 2 = 1,
            // so the rotated order should have the challenge originally at index 1 moved to index 0.
            let dateComponents = DateComponents(year: 2025, month: 1, day: 3)
            guard let testDate = Calendar.current.date(from: dateComponents) else {
                XCTFail("Failed to create test date for rotation.")
                return
            }
            
            let viewModel = ChallengeViewModel()
            viewModel.userId = testUserId
            let challenges = viewModel.getChallenges(for: testDate)
            
            XCTAssertEqual(challenges.count, 2, "There should be 2 challenges for user id \(testUserId).")
            XCTAssertEqual(challenges[0].title, "Challenge B", "After rotation, 'Challenge B' should be the first element.")
            XCTAssertEqual(challenges[1].title, "Challenge A", "After rotation, 'Challenge A' should be the second element.")
        }
    }
}
