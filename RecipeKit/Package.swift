// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RecipeKit",
    platforms: [
        .iOS(.v16),
        // Other platforms are currently unsupported
    ],
    products: [
        .library(name: "ImageCaching", targets: ["ImageCaching"]),
        .library(name: "RecipeKit", targets: ["RecipeKit"]),
    ],
    targets: [
        // Product Targets
        .target(
            name: "ImageCaching",
            dependencies: [
                .target(name: "Logging"),
            ]
        ),
        .target(name: "Logging"),
        .target(
            name: "RecipeKit",
            dependencies: [
                .target(name: "Logging"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "ImageCachingTests",
            dependencies: [
                .target(name: "ImageCaching"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "RecipeKitTests",
            dependencies: [
                .target(name: "RecipeKit"),
            ],
            exclude: [
                "Samples",
            ]
        ),
    ]
)
