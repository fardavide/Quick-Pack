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
        // MARK: - App Storage declaration
        "AppStorage",
        "RealAppStorage",
        // MARK: - Common declaration
        "DateUtils",
        "Design",
        "Presentation",
        "Provider",
        "QpStorage",
        "QpUtils",
        // MARK: - Home declarations
        "HomePresentation",
        // MARK: - Trip declarations
        "TripData",
        "TripDomain",
        // MARK: - TripList declarations
        "TripListPresentation"
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", from: "0.7.0"),
    // .package(url: "https://github.com/kean/Nuke", .upToNextMajor(from: Version(12, 2, 0))),
    .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: Version(4, 1, 1)))
  ],
  targets: [
    
    // MARK: - App Storage definition
    // MARK: App Storage
    .target(
      name: "AppStorage",
      dependencies: [
        "QpUtils"
      ],
      path: "Sources/AppStorage/Api"
    ),
    .testTarget(
      name: "AppStorageTests",
      dependencies: [
        "AppStorage"
      ],
      path: "Tests/AppStorage/ApiTests"
    ),
    
    // MARK: Real App Storage
    .target(
      name: "RealAppStorage",
      dependencies: [
        "AppStorage",
        "Provider",
        "TripData"
      ],
      path: "Sources/AppStorage/Real"
    ),
    .testTarget(
      name: "RealppStorageTests",
      dependencies: [
        "RealAppStorage"
      ],
      path: "Tests/AppStorage/RealTests"
    ),
    
    // MARK: - Common definitions
    // MARK: Date Utils
    .target(
      name: "DateUtils",
      dependencies: [],
      path: "Sources/Common/DateUtils"
    ),
    .testTarget(
      name: "DateUtilsTests",
      dependencies: [
        "DateUtils",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/DateUtilsTests"
    ),
    
    // MARK: Design
    .target(
      name: "Design",
      dependencies: [
        "Presentation",
        "SFSafeSymbols"
      ],
      path: "Sources/Common/Design"
    ),
    .testTarget(
      name: "DesignTests",
      dependencies: [
        "Design",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/DesignTests"
    ),
    
    // MARK: Presentation
    .target(
      name: "Presentation",
      dependencies: [
        "QpUtils"
      ],
      path: "Sources/Common/Presentation"
    ),
    .testTarget(
      name: "PresentationTests",
      dependencies: [
        "Presentation",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/PresentationTests"
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
        "QpUtils"
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
      
    // MARK: Utils
    .target(
      name: "QpUtils",
      dependencies: [],
      path: "Sources/Common/Utils"
    ),
    .testTarget(
      name: "UtilsTests",
      dependencies: [
        "QpUtils",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Common/UtilsTests"
    ),
    
    // MARK: - Home definitions
    // MARK: Home Presentation
    .target(
      name: "HomePresentation",
      dependencies: [
        "Provider",
        "TripListPresentation"
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
    
    // MARK: - Trip definitions
    // MARK: Trip Data
    .target(
      name: "TripData",
      dependencies: [
        "AppStorage",
        "Provider",
        "QpStorage",
        "QpUtils",
        "TripDomain"
      ],
      path: "Sources/Trip/Data"
    ),
    .testTarget(
      name: "TripDataTests",
      dependencies: [
        "TripData",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Trip/DataTests"
    ),
    
    // MARK: Trip Domain
    .target(
      name: "TripDomain",
      dependencies: [
        "DateUtils",
        "Provider",
        "QpUtils"
      ],
      path: "Sources/Trip/Domain"
    ),
    .testTarget(
      name: "TripDomainTests",
      dependencies: [
        "TripDomain",
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/Trip/DomainTests"
    ),
    
    // MARK: - Trip List definitions
    // MARK: Trip List Presentation
    .target(
      name: "TripListPresentation",
      dependencies: [
        "DateUtils",
        "Design",
        "Provider",
        "Presentation",
        "TripDomain"
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
