import Foundation

public extension Recipe {
    static let mockedBananaPancakes: Self = .mocked(
        name: "Banana Pancakes",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
        sourceURL: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
        youtubeURL: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
    )
    
    static let mockedBlackberryFool: Self = .mocked(
        name: "Blackberry Fool",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
        sourceURL: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
        youtubeURL: "https://www.youtube.com/watch?v=kniRGjDLFrQ"
    )
    
    static let mockedEtonMess: Self = .mocked(
        name: "Eton Mess",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/258262f1-57dc-4895-8856-bf95aee43054/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/258262f1-57dc-4895-8856-bf95aee43054/small.jpg",
        youtubeURL: "https://www.youtube.com/watch?v=43WgiNq54L8"
    )
    
    static let mockedRolyPoly: Self = .mocked(
        name: "Roly-Poly",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/5460345d-4057-4ffe-a4ee-0ba9a8b91ed6/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/5460345d-4057-4ffe-a4ee-0ba9a8b91ed6/small.jpg",
        sourceURL: "https://www.bbcgoodfood.com/recipes/13354/jam-rolypoly",
        youtubeURL: "https://www.youtube.com/watch?v=5ZYWVQ8imVA"
    )
    
    static let mockedWalnutRollGuzvara: Self = .mocked(
        name: "Walnut Roll Gužvara",
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f60cd87-20ab-419b-a425-56b7ad7c8566/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f60cd87-20ab-419b-a425-56b7ad7c8566/small.jpg",
        youtubeURL: "https://www.youtube.com/watch?v=Q_akngSJVrQ"
    )
}

public extension Array where Element == Recipe {
    private static let allMockedCases: Self = [
        .mockedBananaPancakes,
        .mockedBlackberryFool,
        .mockedEtonMess,
        .mockedRolyPoly,
        .mockedWalnutRollGuzvara
    ]
    
    static func mocked(count: Int) -> Self {
        (0..<count).compactMap { _ in Self.allMockedCases.randomElement() }
    }
}
