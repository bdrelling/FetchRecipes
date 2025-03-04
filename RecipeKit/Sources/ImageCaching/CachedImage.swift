// Copyright © 2025 Brian Drelling. All rights reserved.

import Logging
import SwiftUI

public struct CachedImage<Content>: View where Content: View {
    // MARK: Properties

    @State private var phase: AsyncImagePhase = .empty

    private let urlString: String?
    private let content: (AsyncImagePhase) -> Content

    private var url: URL? {
        if let urlString {
            return URL(string: urlString)
        } else {
            return nil
        }
    }

    // MARK: Views

    public var body: some View {
        self.content(self.phase)
            .task {
                await self.loadImage()
            }
    }

    // MARK: Initializers

    public init(
        url urlString: String?,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.urlString = urlString
        self.content = content
    }

    // MARK: Methods

    private func loadImage() async {
        guard let url else { return }

        do {
            let image = try await ImageCache.shared.image(at: url)
            self.phase = .success(image)
        } catch {
            Logger.error(error)
            self.phase = .failure(error)
        }
    }
}

// MARK: - Previews

struct CachedImagePreview: View {
    let url: String?

    var body: some View {
        CachedImage(url: self.url) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
                    .padding()
                    .background(.green)
            case let .failure(error):
                Color.red
                    .overlay {
                        Text(error.localizedDescription)
                    }
            case .empty:
                Color.gray
            @unknown default:
                Color.purple
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

#Preview("Success") {
    CachedImagePreview(url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/large.jpg")

    Text("**Note:** This preview requires an internet connection to load successfully.")
        .font(.caption)
        .padding()
}

#Preview("Failure") {
    CachedImagePreview(url: "invalid_url")
}

#Preview("Empty") {
    CachedImagePreview(url: nil)
}
