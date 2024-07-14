import Provider

public final class CleanUpModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { DataCleanUpTask(operation: provider.get()) }
      .register {
        DataCleanUpOperation(
          categoryReposiory: provider.get(),
          itemRepository: provider.get(),
          tripRepository: provider.get()
        )
      }
  }
}
