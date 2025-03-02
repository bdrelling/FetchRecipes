// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RecipeKit",
    products: [
        .library(name: "RecipeKit", targets: ["RecipeKit"]),
    ],
    targets: [
        // Product Targets
        .target(name: "RecipeKit"),
        // Test Targets
        .testTarget(
            name: "RecipeKitTests",
            dependencies: [
                .target(name: "RecipeKit"),
            ]
        ),
    ]
)
