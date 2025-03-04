// Copyright © 2025 Brian Drelling. All rights reserved.

import RecipeKit
import SwiftUI

struct RootView: View {
    // MARK: Properties

    @StateObject private var viewModel: ViewModel

    // MARK: Views

    var body: some View {
        RecipeList(
            recipes: self.viewModel.recipes,
            header: { self.header }
        )
        .task {
            // Prevent initial loading of recipes in Xcode Previews to avoid unnecessary network requests
            // and allow previewing of populated and empty states
            if !.isRunningInXcodePreview {
                await self.viewModel.loadRecipes()
            }
        }
        .refreshable {
            await self.viewModel.loadRecipes()
        }
        .alert(
            "Error",
            isPresented: self.$viewModel.isPresentingErrorAlert,
            presenting: self.viewModel.apiError,
            actions: { _ in },
            message: { error in
                Text(error.localizedDescription)
            }
        )
    }

    @ViewBuilder private var header: some View {
        HStack(spacing: 32) {
            Image(systemName: "chevron.down")
            Text("Pull to Refresh")
                .font(.subheadline)

            Image(systemName: "chevron.down")
        }
        .padding(8)
        .background(Color.primary.colorInvert())
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
        @Published var isPresentingErrorAlert: Bool = false

        @Published var apiError: Error? = nil {
            didSet {
                self.isPresentingErrorAlert = self.apiError != nil
            }
        }

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
                    // Fade between the lists so it isn't such a jarring flash
                    withAnimation(.default) {
                        self.recipes = recipes
                    }
                }
            } catch {
                await MainActor.run {
                    self.apiError = error
                }
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

#Preview("Populated") {
    RootView(recipes: .mocked)
}

#Preview("Empty") {
    RootView(recipes: [])
}
