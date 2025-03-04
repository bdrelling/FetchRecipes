// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation
@testable import ImageCaching
import SwiftUI
import Testing

final class ImageCacheTests {
    // MARK: Properties

    private var testDirectory: URL {
        .init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appending(path: "RecipeApp.RecipeKit.ImageCacheTests", directoryHint: .isDirectory)
            .appending(path: "ImageCache", directoryHint: .isDirectory)
    }

    private var localImageURL: URL = Bundle.module.url(forResource: "recipe_example", withExtension: "jpg")!
    private var remoteImageURL: URL = .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/large.jpg")!

    // MARK: Tests

    @Test
    func testLocalImageDataCachingSucceeds() async throws {
        // GIVEN: A configured ImageCache and a valid local image URL
        let cache = await ImageCache(directory: self.testDirectory)
        let imageURL = self.localImageURL
        let key = "recipe_example.jpg"

        // WHEN: We try to access the cached data BEFORE fetching the image from the URL
        let precachedData = try? await cache.cachedData(forKey: key)

        // THEN: There should be no cached data on disk
        #expect(precachedData == nil)

        // WHEN: We fetch the data through our ImageCache
        let data = try await cache.data(at: imageURL, forKey: key)

        // THEN: The data returned by the function is valid
        #expect(!data.isEmpty)

        // THEN: The cached data should exist on disk
        let cachedData = try await cache.cachedData(forKey: key)
        #expect(!cachedData.isEmpty)

        // WHEN: We remove the cached data
        try await cache.remove(key: key)

        // THEN: The cached data no longer exists on disk
        let emptyCachedData = try? await cache.cachedData(forKey: key)
        #expect(emptyCachedData == nil)
    }

    @Test
    func testRemoteImageCachingSucceeds() async throws {
        // GIVEN: A configured ImageCache and a valid local image URL
        let cache = await ImageCache(directory: self.testDirectory)
        let imageURL = self.remoteImageURL
        let key = imageURL.fileSafeString

        // WHEN: We try to access the cached data BEFORE fetching the image from the URL
        let precachedData = try? await cache.cachedData(forKey: key)

        // THEN: There should be no cached data on disk
        #expect(precachedData == nil)

        // WHEN: We fetch the image through our ImageCache
        // THEN: NO error is thrown an image is successfully returned
        _ = try await cache.image(at: imageURL)

        // THEN: The cached data should exist on disk
        let cachedData = try await cache.cachedData(forKey: key)
        #expect(!cachedData.isEmpty)

        // WHEN: We remove the cached data
        try await cache.remove(key: key)

        // THEN: The cached data no longer exists on disk
        let emptyCachedData = try? await cache.cachedData(forKey: key)
        #expect(emptyCachedData == nil)
    }

    @Test
    func testConvertingURLToFileSafeStringSucceeds() async throws {
        // GIVEN: A remote URL
        let imageURL = self.remoteImageURL

        // WHEN: We parse it into a file-safe String
        let key = imageURL.fileSafeString

        // THEN: It should be a properly sanitized String for storage to disk
        #expect(key == "d3jbb8n5wk0qxi.cloudfront.net_photos_27c50c00-148e-4d2a-abb7-942182bb6d94_large.jpg")
    }

    @Test
    func testCreatingAndClearingCacheSucceeds() async throws {
        // GIVEN: A configured ImageCache with a cache directory created
        let functionDirectory = #function.trimmingCharacters(in: .alphanumerics.inverted)
        let cacheDirectory = self.testDirectory.appending(path: functionDirectory)
        let cache = await ImageCache(directory: cacheDirectory)

        // WHEN: We check to see if the directory exists BEFORE the cache creates it
        // THEN: The directory SHOULD NOT already exist on disk
        #expect(!FileManager.default.fileExists(atPath: cacheDirectory.path()))

        // WHEN: The cache directories are created
        try await cache.createDirectoriesIfNecessary()

        // THEN: The directory SHOULD exist on disk
        #expect(FileManager.default.fileExists(atPath: cacheDirectory.path()))

        // WHEN: The cache is cleared
        try await cache.clear()

        // THEN: The directory SHOULD NOT exist on disk again
        #expect(!FileManager.default.fileExists(atPath: cacheDirectory.path()))
    }
}
