// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

// An API for fetching culinary recipes.
public final class RecipeAPI {
    /// The base URL for the Recipe API.
    static let recipesURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    private let client = HTTPClient()
    private let baseURL: String

    /// An `internal` initializer for testing the `RecipeAPI` with various URLs.
    /// - Parameter baseURL: The URL to fetch recipes from.
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    public convenience init() {
        self.init(baseURL: Self.recipesURL)
    }

    public func getRecipes() async throws -> [Recipe] {
        let response: RecipeResponse = try await self.client.decodedData(from: self.baseURL)
        return response.recipes
    }
}

// MARK: - Supporting Types

enum RecipeAPIError: LocalizedError {
    case invalidURL(_ url: String)

    var errorDescription: String? {
        switch self {
        case let .invalidURL(url): "Invalid URL: \(url)"
        }
    }
}
