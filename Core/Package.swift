// swift-tools-version: 5.10
/// swiftlint:disable file_length

import CompilerPluginSupport
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
        "QpData",
        "Provider",
        "QpStorage",
        // MARK: - Home declarations
        "HomePresentation",
        // MARK: - TripList declarations
        "TripListPresentation"
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", from: "0.6.0")
    // .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: Version(12, 2, 0))),
    // .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: Version(4, 1, 1)))
  ],
  targets: [
    
    // MARK: - Common definitions
    // MARK: Data
    .target(
      name: "QpData",
      path: "Sources/Common/Data"
    ),
    .testTarget(
      name: "QpDataTests",
      dependencies: [
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/DataTests"
    ),
    
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
      
    // MARK: Storage
    .target(
      name: "QpStorage",
      dependencies: [
        "QpData"
      ],
      path: "Sources/Common/Storage"
    ),
    .testTarget(
      name: "StorageTests",
      dependencies: [
        "QpStorage",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/StorageTests"
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
    ),
    
    // MARK: - Trip List definitions
    // MARK: Trip List Presentation
    .target(
      name: "TripListPresentation",
      dependencies: [
        "Provider"
      ],
      path: "Sources/TripList/Presentation"
    ),
    .testTarget(
      name: "TripListPresentationTests",
      dependencies: [
        "TripListPresentation",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/TripList/PresentationTests"
    )
  ]
)
/// swiftlint:enable file_length
