// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

/// A networking client that handles fetching and decoding data.
final class HTTPClient {
    private let decoder = JSONDecoder()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(from url: URL) async throws -> Data {
        let (data, _) = try await self.session.data(from: url)
        return data
    }

    func decodedData<T>(from url: URL) async throws -> T where T: Decodable {
        let data = try await self.data(from: url)
        return try self.decoder.decode(T.self, from: data)
    }
}

// MARK: - Convenience Extensions

extension HTTPClient {
    func data(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw HTTPClientError.invalidURL(urlString)
        }

        return try await self.data(from: url)
    }

    func decodedData<T>(from urlString: String) async throws -> T where T: Decodable {
        guard let url = URL(string: urlString) else {
            throw HTTPClientError.invalidURL(urlString)
        }

        return try await self.decodedData(from: url)
    }
}

// MARK: - Supporting Types

enum HTTPClientError: LocalizedError {
    case invalidURL(_ url: String)

    var errorDescription: String? {
        switch self {
        case let .invalidURL(url): "Invalid URL: \(url)"
        }
    }
}
