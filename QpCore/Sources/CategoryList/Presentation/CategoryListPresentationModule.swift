import Provider

public final class CategoryListPresentationModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealCategoryListViewModel(categoryRepository: provider.get()) as CategoryListViewModel }
  }
}
