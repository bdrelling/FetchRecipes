// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation
@testable import RecipeKit
import Testing

final class HTTPClientTests {
    @Test
    func testValidURLSucceeds() async throws {
        // GIVEN: A valid HTTPClient and a mock JSON endpoint
        let client = HTTPClient()
        let url = "https://httpbin.org/get"

        // WHEN: We fetch data from the endpoint
        let response: HTTPBinGetResponse = try await client.decodedData(from: url)

        // THEN: The data should exist
        #expect(!response.origin.isEmpty)
        #expect(!response.url.absoluteString.isEmpty)
    }

    @Test
    func testInvalidURLThrowsError() async throws {
        // GIVEN: A valid HTTPClient and an INVALID URL
        let client = HTTPClient()
        let url = "invalid_url"

        // WHEN: We fetch data from the invalid endpoint
        // THEN: We expect to receive either our custom internal error or an NSURLError.
        do {
            let _: HTTPBinGetResponse = try await client.decodedData(from: url)
            Issue.record("An error should have been thrown due to an invalid URL")
        } catch HTTPClientError.invalidURL {
            // Success
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain, error.code == -1002 {
                // Success
            } else {
                Issue.record(error, "Incorrect error was thrown")
            }
        }
    }
}

// MARK: - Supporting Types

private struct HTTPBinGetResponse: Decodable {
    var origin: String
    var url: URL
}

