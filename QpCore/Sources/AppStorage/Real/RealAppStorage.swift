import AppStorage
import Foundation
import StorageModels
import SwiftData
import TripData

public final class RealAppStorage: AppStorage {
  
  @MainActor static let instance = RealAppStorage()
  
  private let schema = Schema(
    [
      CategorySwiftDataModel.self,
      ItemSwiftDataModel.self,
      TripItemSwiftDataModel.self,
      TripSwiftDataModel.self
    ],
    version: .init(0, 1, 5)
  )
  
  public let container: ModelContainer
  
  @MainActor private init() {
    do {
      container = try ModelContainer(
        for: schema,
        configurations: ModelConfiguration(schema: schema)
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
