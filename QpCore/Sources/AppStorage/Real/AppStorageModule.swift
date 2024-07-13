import AppStorage
import Provider

public final class AppStorageModule: @preconcurrency Module {
  public init() {}
  
  @MainActor public func register(on provider: Provider) {
    provider
      .register { RealAppStorage.instance as AppStorage }
      .register { RealAppStorage.instance.container }
  }
}
