import ItemDomain
import Provider

public final class ItemDataModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealItemRepository(container: provider.get()) as ItemRepository }
  }
}
