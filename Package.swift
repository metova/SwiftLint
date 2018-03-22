// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftLint",
    products: [
        .library(name: "OpenSwiftLint", targets: ["OpenSwiftLint"]),
        .library(name: "swiftlint", targets: ["swiftlint"]),
        .library(name: "SwiftLintFramework", targets: ["SwiftLintFramework"])

    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.19.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.5.0"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "OpenSwiftLint",
            dependencies: [
                   .target(name: "swiftlint"),
                   .target(name: "SwiftLintFramework"),
            ]//,
            /*path: ".",
            //exclude: [
                "SwiftLintFramework",

               "swiftlint"
            ]*/
        ),
        .target(
            name: "swiftlint",
            dependencies: [
                "Commandant",
                "SwiftLintFramework",
                "SwiftyTextTable",
            ]
        ),
        .target(
            name: "SwiftLintFramework",
            dependencies: [
                "SourceKittenFramework",
                "Yams",
            ]
        ),

        .testTarget(
            name: "SwiftLintFrameworkTests",
            dependencies: [
                "SwiftLintFramework"
            ],
        //    path: "Source",
            exclude: [
                "Resources",
            ]
        )
    ],
    swiftLanguageVersions: [3, 4]
)
