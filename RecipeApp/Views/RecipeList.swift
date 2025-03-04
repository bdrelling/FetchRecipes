// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RecipeList<Header>: View where Header: View {
    // MARK: Properties

    private let recipes: [Recipe]
    private let header: () -> Header

    // MARK: Views

    var body: some View {
        ScrollView([.vertical]) {
            Section(
                content: {
                    Group {
                        if self.recipes.isEmpty {
                            VStack(spacing: 16) {
                                Text("No Recipes Available")
                                    .font(.title3)

                                Text(":(")
                                    .font(.largeTitle)
                            }
                            .padding(.vertical, 64)
                            .opacity(0.35)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(self.recipes, id: \.uuid) { recipe in
                                    RecipeListItem(recipe: recipe)
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                },
                header: self.header
            )
        }
    }

    /// Initializes a `RecipeList` with a custom header.
    init(recipes: [Recipe], @ViewBuilder header: @escaping () -> Header) {
        self.recipes = recipes
        self.header = header
    }
}

// MARK: - Extensions

extension RecipeList where Header == EmptyView {
    /// Initializes a headerless `RecipeList`.
    init(recipes: [Recipe]) {
        self.init(recipes: recipes, header: EmptyView.init)
    }
}

// MARK: - Previews

#Preview("Populated") {
    RecipeList(recipes: .mocked)
}

#Preview("Empty") {
    RecipeList(recipes: [])
}
