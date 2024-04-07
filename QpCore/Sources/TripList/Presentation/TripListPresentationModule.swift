import Provider

public final class TripListPresentionModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealTripListItemUiModelMapper() as TripListItemUiModelMapper }
      .register { TripListViewModel(mapper: provider.get()) }
  }
}
