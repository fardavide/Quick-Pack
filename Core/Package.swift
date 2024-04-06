// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
/// swiftlint:disable file_length

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
      .iOS(.v17),
      .macOS(.v14),
      .tvOS(.v17),
      .watchOS(.v10)
    ],
    products: [
      .library(
        name: "Core",
        targets: [
          // MARK: - Common declaration
          "Provider",
          // MARK: - Home declarations
          "HomePresentation"
        ]
      )
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-testing.git", from: "0.6.0"),
      .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: Version(12, 2, 0))),
      .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: Version(4, 1, 1)))
    ],
    targets: [
      
      // MARK: - Common definitions
      // MARK: Provider
      .target(
        name: "Provider",
        path: "Sources/Common/Provider"
      ),
      .testTarget(
        name: "ProviderTests",
        dependencies: [
          "Provider",
          .product(name: "Testing", package: "swift-testing")
        ],
        path: "Tests/Common/ProviderTests"
      ),
      
      // MARK: - Home definitions
      // MARK: Home Presentation
      .target(
        name: "HomePresentation",
        dependencies: [
          "Provider"
        ],
        path: "Sources/Home/Presentation"
      ),
      .testTarget(
        name: "HomePresentationTests",
        dependencies: [
          "HomePresentation",
          .product(name: "Testing", package: "swift-testing")
        ],
        path: "Tests/Home/PresentationTests"
      )
    ]
)
/// swiftlint:enable file_length
