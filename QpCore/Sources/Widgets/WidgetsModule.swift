import Provider
import RealAppStorage
import TripData

public final class WidgetsModule: Module {
  public var dependencies: [any Module.Type] = [
    AppStorageModule.self,
    TripDataModule.self
  ]
  
  public init() {}
}
