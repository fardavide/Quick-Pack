import Provider

public final class ItemListPresentationModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealItemListViewModel(itemRepository: provider.get()) as ItemListViewModel }
  }
}
