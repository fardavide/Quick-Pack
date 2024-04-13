import AppStorage
import Foundation
import StorageModels
import SwiftData
import TripData

public final class RealAppStorage: AppStorage {
  
  @MainActor static let instance = RealAppStorage()
  
  private let schema = Schema(
    [
      ItemSwiftDataModel.self,
      TripItemSwiftDataModel.self,
      TripSwiftDataModel.self
    ],
    version: .init(0, 0, 2)
  )
  
  public let container: ModelContainer
  
  @MainActor private init() {
    let configuration = ModelConfiguration(
      schema: schema,
      url: URL.documentsDirectory.appending(path: "/q-pack/data.store"),
      cloudKitDatabase: .automatic
    )
    
    do {
      container = try ModelContainer(
        for: schema,
        configurations: configuration
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
