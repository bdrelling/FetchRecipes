// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RecipeList: View {
    var recipes: [Recipe]
    
    var body: some View {
        ScrollView([.vertical]) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(self.recipes) { recipe in
                    RecipeListItem(recipe: recipe)
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

private struct RecipeListItem: View {
    private var name: String
    private var cuisine: String
    private var imageURLString: String?
    
    private var imageURL: URL? {
        if let imageURLString {
            return URL(string: imageURLString)
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            AsyncImage(url: self.imageURL) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Rectangle()
                        .fill(.quaternary)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 120)
            
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
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    init(recipe: Recipe) {
        self.name = recipe.name
        self.cuisine = recipe.cuisine
        
        self.imageURLString = recipe.photoURLSmall
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
    RecipeList(recipes: .mocked(count: 9))
}


struct RecipeAPIKey: EnvironmentKey {
    static let defaultValue: RecipeAPI = .init()
}

extension EnvironmentValues {
   var recipeAPI: RecipeAPI {
       get { self[RecipeAPIKey.self] }
       set { self[RecipeAPIKey.self] = newValue }
   }
}
