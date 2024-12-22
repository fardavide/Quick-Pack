import Provider

public final class TripPresentationModule: Module {
  public var dependencies: [any Module.Type] = []
  
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register {
        RealBuildCountdownText(getCurrentDate: provider.get()) as BuildCountdownText
      }
      .register {
        RealBuildItemsText() as BuildItemsText
      }
  }
}
