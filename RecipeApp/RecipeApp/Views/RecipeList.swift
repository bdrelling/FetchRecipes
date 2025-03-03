// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RecipeList: View {
    var recipes: [Recipe]
    
    var body: some View {
        List(self.recipes) { recipe in
            RecipeView(recipe: recipe)
        }
    }
}

struct RecipeView: View {
    private var name: String
    
    var body: some View {
        Text(self.name)
    }
    
    init(recipe: Recipe) {
        self.name = recipe.name
    }
}

// MARK: - Extensions

extension Recipe: @retroactive Identifiable {
    public var id: String {
        self.uuid
    }
}

// MARK: - Previews

#Preview {
    RecipeList(recipes: .mocked(count: 24))
}
