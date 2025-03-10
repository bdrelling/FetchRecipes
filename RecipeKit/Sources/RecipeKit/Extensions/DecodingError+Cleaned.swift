// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

// Source: https://github.com/bdrelling/Kipple/blob/main/Sources/KippleCodable/Extensions/DecodingError+Cleaned.swift
public extension DecodingError {
    /// A cleaned description for a decoding error that provides additional context about mismatching type, the JSON path, and so on.
    var cleanedDescription: String {
        switch self {
        case let .typeMismatch(type, context):
            return "Type mismatch for key '\(context.codingPath.jsonPath)'. Expected type '\(String(describing: type))'."
        case let .valueNotFound(type, context):
            return "Value not found for key '\(context.codingPath.jsonPath)' of type '\(String(describing: type))'."
        case let .keyNotFound(key, context):
            var allKeys = context.codingPath
            allKeys.append(key)

            return "Key '\(allKeys.jsonPath)' not found."
        case let .dataCorrupted(context) where context.codingPath.isEmpty:
            return "Data corrupted."
        case let .dataCorrupted(context):
            return "Data corrupted at key '\(context.codingPath.jsonPath)'."
        @unknown default:
            return self.localizedDescription
        }
    }
}

// MARK: - Extensions

private extension Array where Element == CodingKey {
    /// The JSON path notation for the given key.
    var jsonPath: String {
        var path = ""

        for key in self {
            if let index = key.intValue {
                path += "[\(index)]"
            } else {
                path += ".\(key.stringValue)"
            }
        }

        return path.trimmingCharacters(in: CharacterSet(charactersIn: "."))
    }
}
