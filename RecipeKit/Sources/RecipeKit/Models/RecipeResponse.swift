/// The data wrapper for the recipe API.
public struct RecipeResponse: Decodable {
    /// A collection of culinary recipes.
    public var recipes: [Recipe]
}
