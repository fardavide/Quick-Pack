import Provider

public final class TripListPresentionModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register {
        TripListViewModel()
      }
  }
}
