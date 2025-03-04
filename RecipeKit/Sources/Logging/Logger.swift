// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

/// A simplified logging system, meant to be easily replaced by something like `OSLog` or `swift-log` after prototyping.
///
/// For now, it relies on printing to the console, regardless of environment, but allows us to classify console messages from the start.
public enum Logger {}

// MARK: - Extensions

public extension Logger {
    static func log(_ message: String) {
        print(message)
    }

    static func warn(_ message: String) {
        print("WARNING: \(message)")
    }

    static func error(_ message: String) {
        print("ERROR: \(message)")
    }

    static func error(_ error: Error) {
        print("ERROR: \(error.localizedDescription)")
    }
}
