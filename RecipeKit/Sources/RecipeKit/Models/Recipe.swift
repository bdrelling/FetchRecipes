// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

/// A culinary recipe.
public struct Recipe: Sendable {
    // MARK: Properties
    
    /// The cuisine of the recipe.
    public var cuisine: String

    /// The name of the recipe.
    public var name: String

    /// The unique identifier for the receipe. Represented as a UUID.
    public var uuid: String

    /// The URL of the recipes’s full-size photo.
    public var photoURLLarge: String?

    /// The URL of the recipes’s small photo. Useful for list view.
    public var photoURLSmall: String?

    /// The URL of the recipe's original website.
    public var sourceURL: String?

    /// The URL of the recipe's YouTube video.
    public var youtubeURL: String?
    
    // MARK: Initializers

    private init(
        cuisine: String,
        name: String,
        uuid: String,
        photoURLLarge: String? = nil,
        photoURLSmall: String? = nil,
        sourceURL: String? = nil,
        youtubeURL: String? = nil
    ) {
        self.cuisine = cuisine
        self.name = name
        self.uuid = uuid
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}

// MARK: - Extensions

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case uuid
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

// MARK: - Extensions

public extension Recipe {
    /// Initializes a **mocked** Recipe, for use with SwiftUI previews and testing.
    static func mocked(
        name: String,
        uuid: String? = nil,
        photoURLLarge: String? = nil,
        photoURLSmall: String? = nil,
        sourceURL: String? = nil,
        youtubeURL: String? = nil
    ) -> Self {
        // Enforcing cuisine to be "Mocked" ensures we don't accidentally misuse these types in production
        let cuisine = "Mocked"

        // Allow a custom UUID to be set, but otherwise just use a random UUID
        // so that we can re-use the same mocked object multiple times as necessary.
        let uuid = uuid ?? UUID().uuidString

        return self.init(
            cuisine: cuisine,
            name: name,
            uuid: uuid,
            photoURLLarge: photoURLLarge,
            photoURLSmall: photoURLSmall,
            sourceURL: sourceURL,
            youtubeURL: youtubeURL
        )
    }
}
