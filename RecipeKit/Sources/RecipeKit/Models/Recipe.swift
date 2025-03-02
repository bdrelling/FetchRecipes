// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

/// A culinary recipe.
public struct Recipe {
    /// The cuisine of the recipe.
    public var cuisine: String

    /// The name of the recipe.
    public var name: String

    /// The URL of the recipes’s full-size photo.
    public var photoURLLarge: URL?

    /// The URL of the recipes’s small photo. Useful for list view.
    public var photoURLSmall: URL?

    /// The unique identifier for the receipe. Represented as a UUID.
    public var uuid: UUID

    /// The URL of the recipe's original website.
    public var sourceURL: URL?

    /// The URL of the recipe's YouTube video.
    public var youtubeURL: URL?
}

// MARK: - Extensions

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
