// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

// MARK: - First level
private let About = "About"
private let AppStorage = "AppStorage"
private let Category = "Category"
private let CategoryList = "CategoryList"
private let CleanUp = "CleanUp"
private let Common = "Common"
private let EditTrip = "EditTrip"
private let Home = "Home"
private let Item = "Item"
private let ItemList = "ItemList"
private let Notifications = "Notifications"
private let Settings = "Settings"
private let SfSafeSymbols = "SFSafeSymbols"
private let Trip = "Trip"
private let TripList = "TripList"
private let Widgets = "Widgets"

// MARK: - Second level
private let Api = "Api"
private let Data = "Data"
private let DateUtils = "DateUtils"
private let Design = "Design"
private let Domain = "Domain"
private let Models = "Models"
private let Presentation = "Presentation"
private let Provider = "Provider"
private let Real = "Real"
private let Storage = "QpStorage"
private let StorageModels = "StorageModels"
private let Undo = "Undo"
private let Utils = "QpUtils"

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
        // MARK: - About declarations
        About+Domain,
        // MARK: - App Storage declarations
        AppStorage,
        Real+AppStorage,
        StorageModels,
        // MARK: - Category declarations
        Category+Data,
        Category+Domain,
        // MARK: - Category List declarations
        CategoryList+Presentation,
        // MARK: - Clean Up declarations
        CleanUp,
        // MARK: - Common declarations
        DateUtils,
        Design,
        Presentation,
        Provider,
        Storage,
        Undo,
        Utils,
        // MARK: - Edit Trip declarations
        EditTrip+Presentation,
        // MARK: - Home declarations
        Home+Presentation,
        // MARK: - Item declarations
        Item+Data,
        Item+Domain,
        // MARK: - Item List declarations
        ItemList+Presentation,
        // MARK: - Notifications declarations
        Notifications,
        // MARK: - Settings declarations
        Settings+Presentation,
        // MARK: - Trip declarations
        Trip+Data,
        Trip+Domain,
        // MARK: - Trip List declarations
        TripList+Presentation,
        // MARK: - Widgets
        Widgets
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", from: "0.12.0"),
    .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: Version(5, 3, 0)))
  ],
  targets: [
    
    // MARK: - About definition
    // MARK: About Domain
    .target(
      path: [About, Domain],
      dependencies: [
        Provider,
        Utils
      ]
    ),
    .testTarget(path: [About, Domain]),
    
    // MARK: - App Storage definition
    // MARK: App Storage
    .target(
      name: AppStorage,
      path: [AppStorage, Api],
      dependencies: [
        Storage,
        Undo
      ]
    ),
    .testTarget(
      name: AppStorage,
      path: [AppStorage, Api]
    ),
    
    // MARK: Real App Storage
    .target(
      name: Real+AppStorage,
      path: [AppStorage, Real],
      dependencies: [
        AppStorage,
        Provider,
        Storage,
        Trip+Data,
        Trip+Domain
      ]
    ),
    .testTarget(
      name: Real+AppStorage,
      path: [AppStorage, Real]
    ),
    
    // MARK: Models
    .target(
      name: StorageModels,
      path: [AppStorage, Models],
      dependencies: [
        AppStorage,
        Item+Domain,
        Trip+Domain
      ]
    ),
    
    // MARK: - Category definitions
    // MARK: Category Data
      .target(
        path: [Category, Data],
        dependencies: [
          AppStorage,
          Category+Domain,
          Utils,
          StorageModels
        ]
      ),
    .testTarget(path: [Category, Data]),
    
    // MARK: Category Domain
    .target(
      path: [Category, Domain],
      dependencies: [
        Undo,
        Utils
      ]
    ),
    .testTarget(path: [Category, Domain]),
    
    // MARK: - Category List definitions
    // MARK: Category List Presentation
    .target(
      path: [CategoryList, Presentation],
      dependencies: [
        Design,
        Category+Domain,
        Presentation,
        Provider,
        Undo
      ]
    ),
    .testTarget(path: [CategoryList, Presentation]),
    
    // MARK: - Clean Up definitions
    .target(
      path: [CleanUp],
      dependencies: [
        Category+Domain,
        Item+Domain,
        Provider,
        Trip+Domain
      ]
    ),
    .testTarget(path: [CleanUp]),

    // MARK: - Common definitions
    // MARK: Date Utils
    .target(
      path: [Common, DateUtils],
      dependencies: [
        Provider
      ]
    ),
    .testTarget(path: [Common, DateUtils]),
    
    // MARK: Design
    .target(
      path: [Common, Design],
      dependencies: [
        Presentation,
        SfSafeSymbols
      ]
    ),
    .testTarget(path: [Common, Design]),
    
    // MARK: Presentation
    .target(
      path: [Common, Presentation],
      dependencies: [
        Utils
      ]
    ),
    .testTarget(path: [Common, Presentation]),
    
    // MARK: Provider
    .target(
      path: [Common, Provider],
      dependencies: []
    ),
    .testTarget(path: [Common, Provider]),
      
    // MARK: Storage
    .target(
      path: [Common, Storage],
      dependencies: [
        Utils
      ]
    ),
    .testTarget(path: [Common, Storage]),
    
    // MARK: Undo
    .target(
      path: [Common, Undo],
      dependencies: [
        Design,
        Utils
      ]
    ),
    .testTarget(path: [Common, Undo]),
      
    // MARK: Utils
    .target(
      path: [Common, Utils],
      dependencies: []
    ),
    .testTarget(path: [Common, Utils]),
    
    // MARK: - Edit Trip definitions
    // MARK: Edit Trip Presentation
    .target(
      path: [EditTrip, Presentation],
      dependencies: [
        Design,
        Notifications,
        Presentation,
        Provider,
        Trip+Domain
      ]
    ),
    .testTarget(path: [EditTrip, Presentation]),
    
    // MARK: - Item definitions
    // MARK: Item Data
    .target(
      path: [Item, Data],
      dependencies: [
        AppStorage,
        Item+Domain,
        Utils,
        StorageModels
      ]
    ),
    .testTarget(path: [Item, Data]),
    
    // MARK: Item Domain
    .target(
      path: [Item, Domain],
      dependencies: [
        Category+Domain,
        Undo,
        Utils
      ]
    ),
    .testTarget(path: [Item, Domain]),
    
    // MARK: - Home definitions
    // MARK: Home Presentation
    .target(
      path: [Home, Presentation],
      dependencies: [
        EditTrip+Presentation,
        Provider,
        TripList+Presentation
      ]
    ),
    .testTarget(path: [Home, Presentation]),
    
    // MARK: - Item List definitions
    // MARK: Item List Presentation
    .target(
      path: [ItemList, Presentation],
      dependencies: [
        Design,
        Item+Domain,
        Presentation,
        Provider,
        Undo
      ]
    ),
    .testTarget(path: [ItemList, Presentation]),
    
    // MARK: - Notifications definitions
    .target(
      path: [Notifications],
      dependencies: [
        DateUtils,
        Provider,
        Trip+Domain
      ]
    ),
    .testTarget(path: [Notifications]),
    
    // MARK: - Settings definitions
    // MARK: Settings Presentation
    .target(
      path: [Settings, Presentation],
      dependencies: [
        About+Domain,
        CategoryList+Presentation,
        Design,
        ItemList+Presentation,
        Provider,
        Presentation
      ]
    ),
    .testTarget(path: [Settings, Presentation]),
    
    // MARK: - Trip definitions
    // MARK: Trip Data
    .target(
      path: [Trip, Data],
      dependencies: [
        AppStorage,
        Item+Data,
        Provider,
        Storage,
        StorageModels,
        Trip+Domain,
        Utils
      ]
    ),
    .testTarget(path: [Trip, Data]),
    
    // MARK: Trip Domain
    .target(
      path: [Trip, Domain],
      dependencies: [
        DateUtils,
        Item+Domain,
        Provider,
        Undo,
        Utils
      ]
    ),
    .testTarget(path: [Trip, Domain]),
    
    // MARK: - Trip List definitions
    // MARK: Trip List Presentation
    .target(
      path: [TripList, Presentation],
      dependencies: [
        DateUtils,
        Design,
        EditTrip+Presentation,
        Provider,
        Presentation,
        Settings+Presentation,
        Trip+Domain,
        Undo
      ]
    ),
    .testTarget(path: [TripList, Presentation]),
    
    // MARK: - Widgets definitions
    // MARK: Widgets
    .target(
      path: [Widgets],
      dependencies: [
        Real+AppStorage,
        DateUtils,
        Provider,
        Trip+Domain
      ]
    ),
    .testTarget(path: [Widgets])
  ],
  
  swiftLanguageVersions: [SwiftVersion.v6]
)

private extension Target {
  
  static func target(
    name: String? = nil,
    path: [String],
    dependencies: [String]
  ) -> Target {
    let name = name ?? getName(from: path)
    let stringPath = normalize(path)
    return .target(
      name: name,
      dependencies: dependencies.map { Target.Dependency(stringLiteral: $0) },
      path: "Sources/\(stringPath)"
    )
  }
  
  static func testTarget(
    name: String? = nil,
    path: [String]
  ) -> Target {
    let name = name ?? getName(from: path)
    let stringPath = normalize(path)
    return .testTarget(
      name: "\(name)Tests",
      dependencies: [
        Target.Dependency(stringLiteral: name),
        .product(name: "Testing", package: "swift-testing")
      ],
      path: "Tests/\(stringPath)Tests"
    )
  }
  
  private static func getName(from path: [String]) -> String {
    path
      .filter { $0 != Common }
      .joined(separator: "")
  }
  
  private static func normalize(_ path: [String]) -> String {
    path
      .map { $0.replacing("Qp", with: "") }
      .joined(separator: "/")
  }
}
