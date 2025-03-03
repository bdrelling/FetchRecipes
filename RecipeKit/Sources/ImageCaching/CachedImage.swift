// Copyright © 2025 Brian Drelling. All rights reserved.

import SwiftUI

public struct CachedImage<Content>: View where Content: View {
    // MARK: Properties
    
    @State private var image: Image?

    private let url: URL?
    private let content: (Image?) -> Content
    
    // MARK: Views

    public var body: some View {
        self.content(self.image)
            .task {
                if let url {
                    // TODO: Fix the try
                    self.image = try! await ImageCache.shared.image(at: url)
                }
            }
    }
    
    // MARK: Initializers

    public init(
        url: URL? = nil,
        @ViewBuilder content: @escaping (Image?) -> Content
    ) {
        self.url = url
        self.content = content
    }

    public init(
        url urlString: String,
        @ViewBuilder content: @escaping (Image?) -> Content
    ) {
        self.init(
            url: URL(string: urlString),
            content: content
        )
    }
}

// MARK: - Previews

#Preview {
    CachedImage(url: "test") { image in
        if let image {
            image.resizable()
        } else {
            Color.blue
        }
    }
}

//
// AsyncImage(url: self.imageURL) { phase in
//    if let image = phase.image {
//        image.resizable()
//    } else {
//        Rectangle()
//            .fill(.quaternary)
//    }
// }
// .aspectRatio(1, contentMode: .fit)
// .frame(width: 120)
