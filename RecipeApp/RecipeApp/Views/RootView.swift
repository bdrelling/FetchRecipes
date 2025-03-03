import RecipeKit
import SwiftUI

struct RootView: View {
    @StateObject var viewModel: RootViewModel
    
    var body: some View {
        RecipeList(recipes: self.viewModel.recipes)
            .task {
                // Prevent unnecessary network requests in Xcode Previews.
                if !.isRunningInXcodePreview {
                    await self.viewModel.loadRecipes()
                }
            }
            .refreshable {
                await self.viewModel.loadRecipes()
            }
    }
    
    init(viewModel: RootViewModel? = nil) {
        self._viewModel = .init(wrappedValue: viewModel ?? .init())
    }
}

// MARK: - Supporting Types

final class RootViewModel: ObservableObject {
    private let api = RecipeAPI()
    
    @Published var recipes: [Recipe]
    @Published var apiError: Error? = nil
    
    init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }
    
    func loadRecipes() async {
        do {
            let recipes = try await self.api.getRecipes()
                .sorted { $0.name < $1.name }
            
            await MainActor.run {
                self.recipes = recipes
            }
        } catch {
            self.apiError = error
        }
    }
}

// MARK: - Previews

/// Private extensions for supporting Xcode Previews.
private extension RootView {
    init(recipes: [Recipe]) {
        self.init(viewModel: .init(recipes: recipes))
    }
}

#Preview {
    RootView(recipes: .mocked(count: 30))
}
