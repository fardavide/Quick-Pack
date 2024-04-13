import AppStorage
import Foundation
import StorageModels
import SwiftData
import TripData

public final class RealAppStorage: AppStorage {
  
  static let instance = RealAppStorage()
  
  private let schema = Schema(
    [
      TripSwiftDataModel.self
    ],
    version: .init(0, 0, 1)
  )
  
  public let container: ModelContainer
  
  private init() {
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
      Task { await setUndo() }
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  @MainActor
  private func setUndo() {
    container.mainContext.undoManager = UndoManager()
  }
}
