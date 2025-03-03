// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RootView: View {
    // MARK: Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: Views

    var body: some View {
        RecipeList(recipes: self.viewModel.recipes)
            .task {
                // Prevent network request on load in Xcode Previews
                if !.isRunningInXcodePreview {
                    await self.viewModel.loadRecipes()
                }
            }
            .refreshable {
                await self.viewModel.loadRecipes()
            }
    }
    
    // MARK: Initializers

    init(viewModel: ViewModel? = nil) {
        self._viewModel = .init(wrappedValue: viewModel ?? .init())
    }
}

// MARK: - Supporting Types

extension RootView {
    final class ViewModel: ObservableObject {
        // MARK: Properties
        
        private let api = RecipeAPI()

        @Published var recipes: [Recipe]
        // TODO: Display error in UI
        @Published var apiError: Error? = nil
        
        // MARK: Initializers

        init(recipes: [Recipe] = []) {
            self.recipes = recipes
        }
        
        // MARK: Methods

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
}

// MARK: - Previews

/// Private extensions for supporting Xcode Previews.
private extension RootView {
    init(recipes: [Recipe]) {
        self.init(viewModel: .init(recipes: recipes))
    }
}

#Preview {
    RootView(recipes: .mocked)
}
