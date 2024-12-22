import Provider
import RealAppStorage
import TripData
import TripPresentation

public final class WidgetsModule: Module {
  public var dependencies: [any Module.Type] = [
    AppStorageModule.self,
    TripDataModule.self,
    TripPresentationModule.self
  ]
  
  public init() {}
}
