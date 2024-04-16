import EditTripPresentation
import Provider
import SettingsPresentation

public final class TripListPresentionModule: Module {
  public init() {}
  
  public var dependencies: [any Module.Type] = [
    EditTripPresentationModule.self,
    SettingsPresentationModule.self
  ]
  
  public func register(on provider: Provider) {
    provider
      .register { RealTripListItemUiModelMapper() as TripListItemUiModelMapper }
      .register {
        TripListViewModel(
          editTripViewModelFactory: provider.get(),
          mapper: provider.get(),
          settingsViewModel: provider.get(),
          tripRepository: provider.get()
        )
      }
  }
}
