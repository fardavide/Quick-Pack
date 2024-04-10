import Provider

public final class EditTripPresentationModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register {
        EditTripViewModel.RealFactory(
          tripRepository: provider.get()
        ) as any EditTripViewModel.Factory
      }
  }
}