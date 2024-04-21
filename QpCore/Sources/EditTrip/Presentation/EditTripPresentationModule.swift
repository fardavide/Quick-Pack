import Provider

public final class EditTripPresentationModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register {
        EditTripViewModel.RealFactory(
          categoryRepository: provider.get(),
          itemRepository: provider.get(),
          tripRepository: provider.get()
        ) as any EditTripViewModel.Factory
      }
  }
}
