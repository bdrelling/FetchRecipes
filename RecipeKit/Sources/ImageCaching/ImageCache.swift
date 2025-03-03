// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation
import Logging
import SwiftUI

/// Cache image data to disk.
@CacheActor
public final class ImageCache {
    // MARK: Shared Instance
    
    public static let shared = ImageCache()
    
    // MARK: Properties

    private var hasCreatedDirectories: Bool = false
    private let fileManager: FileManager = .default
    private let cacheDirectory: URL
    
    // MARK: Initializers

    /// Initializes a new `ImageCache` for a provided directory.
    /// - Parameter directory: The directory to store cached data within. Defaults to the user domain's cache directory if possible.
    init(directory: URL? = nil) {
        self.cacheDirectory = directory ?? self.fileManager.defaultImageCacheDirectory
        Logger.log("ImageCache initialized; cached images will be stored in '\(self.cacheDirectory)'")
    }
    
    // MARK: Methods
    
    public func clear() throws {
        // Remove only the cache directory, leaving its parent directories intact
        try self.fileManager.removeItem(at: self.cacheDirectory)
        
        // Rather than recreating directories immediately, allow the ImageCache to handle it automatically when caching
        self.hasCreatedDirectories = false
    }

    /// Fetches the `Image` from a provided remote `URL` and caches it for future access.
    /// - Parameters:
    ///   - url: The remote `URL` to fetch the data from.
    ///   - key: The identifier to use for accessing and caching the image data. If no value is provided, the key will default to a filesafe representation of the `URL`.
    /// - Returns: A SwiftUI `Image`.
    public func image(at url: URL, forKey key: String? = nil) async throws -> Image {
        let data = try await self.data(at: url, forKey: key)

        guard let uiImage = UIImage(data: data) else {
            throw ImageCacheError.unableToCreateUIImageFromData
        }

        return Image(uiImage: uiImage)
    }

    /// Fetches the `Data` for an image from a provided remote `URL`.
    /// - Parameters:
    ///   - url: The remote `URL` to fetch the data from.
    ///   - key: The identifier to use for accessing and caching the image data. If no value is provided, the key will default to a filesafe representation of the `URL`.
    /// - Returns: The `Data` for the image.
    func data(at url: URL, forKey key: String? = nil) async throws -> Data {
        let key = key ?? url.fileSafeString
        
        if let cachedData = try? self.cachedData(forKey: key) {
            return cachedData
        }

        let data = try Data(contentsOf: url)

        try await self.cache(data, forKey: key)

        return data
    }
    
    func cachedData(forKey key: String) throws -> Data {
        let cacheURL = self.cacheURL(forKey: key)
        let data = try Data(contentsOf: cacheURL)
        
        Logger.log("Fetched cached image data for key '\(key)'")
        
        return data
    }
    
    func remove(key: String) throws {
        let cacheURL = self.cacheURL(forKey: key)
        try self.fileManager.removeItem(at: cacheURL)
        
        Logger.log("Removed cached image data for key '\(key)'")
    }
    
    func cacheURL(forKey key: String) -> URL {
        return self.cacheDirectory.appendingPathComponent(key)
    }
    
    /// Creates directories on disk for image caching.
    /// 
    /// This is a lightweight operation that only needs to be called _before_ caching data; fetched data would not benefit from empty directories existing.
    func createDirectoriesIfNecessary() throws {
        guard !self.hasCreatedDirectories else {
            return
        }

        try self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true)
        
        self.hasCreatedDirectories = true
        
        Logger.log("Created ImageCache directory at '\(self.cacheDirectory.absoluteString)'")
    }
    
    private func cache(_ data: Data, forKey key: String) async throws {
        try self.createDirectoriesIfNecessary()
        
        let cacheURL = self.cacheURL(forKey: key)
        
        try data.write(to: cacheURL)
        
        Logger.log("Cached image data for key '\(key)'")
    }
}

// MARK: - Supporting Types

@globalActor
public actor CacheActor: GlobalActor {
    public static let shared = CacheActor()
}

public enum ImageCacheError: LocalizedError {
    case unableToCreateUIImageFromData

    public var errorDescription: String? {
        switch self {
        case .unableToCreateUIImageFromData: "Unable to create UIImage from Data"
        }
    }
}

// MARK: - Extensions

private extension FileManager {
    /// A directory for caching data.
    /// Utilizes the `.cachesDirectory` if possible; otherwise, falls back on `NSTemporaryDirectory()`.
    var safeCacheDirectory: URL {
        // Safely fall back to the temporary directory if the cache directory cannot be accessed.
        if let cachesDirectory = self.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return cachesDirectory
        } else {
            Logger.warn("Cache directory not found")

            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appending(path: "RecipeApp", directoryHint: .isDirectory)
        }
    }

    /// The default directory for caching images with the `ImageCache`.
    var defaultImageCacheDirectory: URL {
        self.safeCacheDirectory
            .appending(path: "ImageCache", directoryHint: .isDirectory)
    }
}

extension URL {
    var fileSafeString: String {
        var absoluteString: String = self.absoluteString
        
        if let scheme {
            absoluteString = absoluteString.replacingOccurrences(of: "\(scheme)://", with: "")
        }
        
        return absoluteString
            .replacingOccurrences(of: "[\\/:*?\"<>|]", with: "_", options: .regularExpression)
    }
}
