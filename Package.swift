// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-segment",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Segment", targets: ["Segment"])],
    traits: [
        .trait(name: "Affine", description: "Affine integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-time.git", branch: "main", traits: [.trait(name: "Affine", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-clock.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-vector.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-translation.git", branch: "main", traits: [.trait(name: "Affine", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-displacement.git", branch: "main", traits: [.trait(name: "Tagged", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-coordinate.git", branch: "main", traits: [.trait(name: "Tagged", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-affine.git", branch: "main", traits: [.trait(name: "Tagged", condition: .when(traits: ["Affine"])), .trait(name: "Vector", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-point.git", branch: "main", traits: [.trait(name: "Tagged", condition: .when(traits: ["Affine"])), .trait(name: "Affine", condition: .when(traits: ["Affine"]))]),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .testTarget(name: "Segment Temporal Integration Tests", dependencies: [
                .target(name: "Segment"),
                .product(name: "Clock", package: "swift-clock", condition: .when(traits: ["Affine"])),
                .product(name: "Time", package: "swift-time", condition: .when(traits: ["Affine"])),
                .product(name: "Affine", package: "swift-affine", condition: .when(traits: ["Affine"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Affine"])),
                .product(name: "Coordinate", package: "swift-coordinate", condition: .when(traits: ["Affine"]))
            ], path: "Tests/Segment Temporal Integration Tests"),
        .testTarget(name: "Segment Affine Tests", dependencies: [
                .target(name: "Segment"),
                .product(name: "Affine", package: "swift-affine", condition: .when(traits: ["Affine"])),
                .product(name: "Point", package: "swift-point", condition: .when(traits: ["Affine"])),
                .product(name: "Coordinate", package: "swift-coordinate", condition: .when(traits: ["Affine"])),
                .product(name: "Displacement", package: "swift-displacement", condition: .when(traits: ["Affine"])),
                .product(name: "Translation", package: "swift-translation", condition: .when(traits: ["Affine"])),
                .product(name: "Vector", package: "swift-vector", condition: .when(traits: ["Affine"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Affine"]))
            ], path: "Tests/Segment Affine Tests"),
        .target(name: "Segment", dependencies: [.product(name: "Affine", package: "swift-affine", condition: .when(traits: ["Affine"]))]),
        .testTarget(name: "Segment Tests", dependencies: [
            .target(name: "Segment"),
            .product(name: "Point", package: "swift-point"),
            .product(name: "Tagged", package: "swift-tagged"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
