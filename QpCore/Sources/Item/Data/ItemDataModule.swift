import ItemDomain
import Provider

public final class ItemDataModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealItemRepository(context: provider.get()) as ItemRepository }
  }
}
