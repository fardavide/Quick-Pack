import AboutDomain
import ItemListPresentation
import Provider

public final class SettingsPresentationModule: Module {
  public init() {}
  
  public var dependencies: [Module.Type] = [
    AboutDomainModule.self,
    ItemListPresentationModule.self
  ]
  
  public func register(on provider: Provider) {
    provider.register {
      RealSettingsViewModel(
        getAppVersion: provider.get(),
        itemListViewModel: provider.get()
      ) as SettingsViewModel
    }
  }
}
