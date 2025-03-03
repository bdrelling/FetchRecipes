import SwiftUI

struct RootView: View {
    var body: some View {
        RecipeList(recipes: [])
    }
}

// MARK: - Previews

#Preview {
    RootView()
}
