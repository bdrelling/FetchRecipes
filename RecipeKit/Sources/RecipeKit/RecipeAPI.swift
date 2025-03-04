// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

// An API for fetching culinary recipes.
public final class RecipeAPI {
    // MARK: Constants

    /// The base URL for the Recipe API.
    static let recipesURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    // MARK: Properties

    private let client = HTTPClient()
    private let baseURL: String

    // MARK: Initializers

    /// An `internal` initializer for testing the `RecipeAPI` with various URLs.
    /// - Parameter baseURL: The URL to fetch recipes from.
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    public convenience init() {
        self.init(baseURL: Self.recipesURL)
    }

    // MARK: Methods

    public func getRecipes() async throws -> [Recipe] {
        do {
            let response: RecipeResponse = try await self.client.decodedData(from: self.baseURL)
            return response.recipes
        } catch let error as DecodingError {
            throw RecipeAPIError.unableToDecode(RecipeResponse.self, decodingError: error)
        } catch {
            throw error
        }
    }
}

// MARK: - Supporting Types

public enum RecipeAPIError: LocalizedError {
    case invalidURL(_ url: String)
    case unableToDecode(_ type: Decodable.Type, decodingError: DecodingError)

    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url): "Invalid URL: \(url)"
        case let .unableToDecode(type, error): "Unable to decode \(String(describing: type)); \(error.cleanedDescription)"
        }
    }
}
