// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RecipeList: View {
    // MARK: Properties
    
    let recipes: [Recipe]
    
    // MARK: Views

    var body: some View {
        ScrollView([.vertical]) {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(self.recipes, id: \.uuid) { recipe in
                    RecipeListItem(recipe: recipe)
                }
            }
            .padding()
        }
    }
}

// MARK: - Previews

#Preview {
    RecipeList(recipes: .mocked)
}
