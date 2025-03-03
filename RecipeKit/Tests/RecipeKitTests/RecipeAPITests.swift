// Copyright © 2025 Brian Drelling. All rights reserved.

@testable import RecipeKit
import Testing

final class RecipeAPITests {
    @Test
    func testGetRawRecipeDataSucceeds() async throws {
        // GIVEN: A valid HTTPClient and recipes API url
        let client = HTTPClient()
        let url = RecipeAPI.recipesURL

        // WHEN: A request is made to fetch recipes
        let response = try await client.data(from: url)

        // THEN: We receive a non-empty response, which ensures that the API is alive
        #expect(!response.isEmpty, "Response should not be empty")
    }

    @Test
    func testGetRecipesSucceeds() async throws {
        // GIVEN: A valid RecipeAPI object is configured
        let api = RecipeAPI()

        // WHEN: A request is made to fetch recipes
        let recipes = try await api.getRecipes()

        // THEN: We receive a non-empty response, which ensures that decoding worked successfully
        #expect(!recipes.isEmpty, "Recipes collection should not be empty")
    }

    @Test
    func testGetEmptyRecipesSuceeds() async throws {
        // GIVEN: An invalid RecipeAPI object is configured with a URL that returns an empty recipe list
        let emptyRecipesURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        let api = RecipeAPI(baseURL: emptyRecipesURL)

        // WHEN: A request is made to fetch recipes from the URL
        let recipes = try await api.getRecipes()

        // THEN: We receive an empty response with NO errors thrown
        #expect(recipes.isEmpty, "Recipes collection should be empty")
    }

    @Test
    func testGetMalformedRecipesThrowsError() async throws {
        // GIVEN: An invalid RecipeAPI object is configured with a URL that returns malformed recipe data
        let malformedRecipesURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        let api = RecipeAPI(baseURL: malformedRecipesURL)

        // WHEN: A request is made to fetch recipes from the URL
        // THEN: A DecodingError is thrown
        do {
            _ = try await api.getRecipes()
            Issue.record("An error should have been thrown due malformed data")
        } catch is DecodingError {
            // Success
        } catch {
            Issue.record(error, "Incorrect error was thrown")
        }
    }
}
