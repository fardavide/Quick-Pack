import AboutDomain
import CategoryListPresentation
import ItemListPresentation
import Provider

public final class SettingsPresentationModule: Module {
  public init() {}
  
  public var dependencies: [Module.Type] = [
    AboutDomainModule.self,
    CategoryListPresentationModule.self,
    ItemListPresentationModule.self
  ]
  
  public func register(on provider: Provider) {
    provider.register {
      RealSettingsViewModel(
        categoryListViewModel: provider.get(),
        getAppVersion: provider.get(),
        itemListViewModel: provider.get()
      ) as SettingsViewModel
    }
  }
}
