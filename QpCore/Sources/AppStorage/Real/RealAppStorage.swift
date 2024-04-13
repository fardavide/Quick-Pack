import AppStorage
import Foundation
import StorageModels
import SwiftData
import TripData

public final class RealAppStorage: AppStorage {
  
  static let instance = RealAppStorage()
  
  private let schema = Schema(
    [
      ItemSwiftDataModel.self,
      TripItemSwiftDataModel.self,
      TripSwiftDataModel.self
    ],
    version: .init(0, 0, 2)
  )
  
  public let context: ModelContext
  public let undoManager: UndoManager
  
  private init() {
    let configuration = ModelConfiguration(
      schema: schema,
      url: URL.documentsDirectory.appending(path: "/q-pack/data.store"),
      cloudKitDatabase: .automatic
    )
    
    do {
      let container = try ModelContainer(
        for: schema,
        configurations: configuration
      )
      context = ModelContext(container)
      undoManager = UndoManager()
      context.undoManager = undoManager
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
