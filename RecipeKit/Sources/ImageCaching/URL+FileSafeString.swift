// Copyright © 2025 Brian Drelling. All rights reserved.

import Foundation

extension URL {
    var fileSafeString: String {
        var absoluteString: String = self.absoluteString

        if let scheme {
            absoluteString = absoluteString.replacingOccurrences(of: "\(scheme)://", with: "")
        }

        return
            absoluteString
                .replacingOccurrences(of: "[\\/:*?\"<>|]", with: "_", options: .regularExpression)
    }
}
