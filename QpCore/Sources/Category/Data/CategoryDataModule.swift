import CategoryDomain
import Provider

public final class CategoryDataModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealCategoryRepository(container: provider.get()) as CategoryRepository }
  }
}
