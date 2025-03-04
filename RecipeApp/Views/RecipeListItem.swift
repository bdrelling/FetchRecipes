// Copyright © 2025 Brian Drelling. All rights reserved.

import ImageCaching
import RecipeKit
import SwiftUI

struct RecipeListItem: View {
    // MARK: Properties

    private var name: String
    private var cuisine: String
    private var imageURL: String?

    private let imageWidth: CGFloat = 120

    // MARK: Views

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            self.image
            self.details
        }
        .background(.quinary)
        .frame(maxHeight: self.imageWidth)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder private var image: some View {
        CachedImage(url: self.imageURL) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
            case .failure:
                Rectangle()
                    .fill(.red)
                    .overlay {
                        Image(systemName: "photo.badge.exclamationmark")
                            .foregroundStyle(.white)
                    }
            case .empty:
                Rectangle()
                    .fill(.quaternary)
            @unknown default:
                Rectangle()
                    .fill(.quaternary)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(width: self.imageWidth)
    }

    @ViewBuilder private var details: some View {
        VStack(alignment: .leading) {
            Text(self.name)
                .font(.headline)
                .lineLimit(3)

            Spacer()

            HStack {
                Spacer()
                Text(self.cuisine)
                    .font(.footnote)
                    .opacity(0.35)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }

    // MARK: Initializers

    init(recipe: Recipe) {
        self.name = recipe.name
        self.cuisine = recipe.cuisine

        self.imageURL = recipe.photoURLSmall
    }
}

// MARK: - Previews

#Preview("Success") {
    RecipeListItem(recipe: .mockedBlackberryFool)
        .padding()
}

#Preview("Failure") {
    RecipeListItem(recipe: .mockedInvalidURLs)
        .padding()
}
