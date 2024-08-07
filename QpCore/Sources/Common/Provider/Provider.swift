public final class Provider {
  
  private var factories: [Key: () -> Any] = [:]
  
  @discardableResult
  @MainActor public func register<Output>(_ createInstance: @MainActor @escaping () -> Output) -> Provider {
    let key = Key(Output.self)
    factories[key] = createInstance
    return self
  }
  
  public func safeGet<T>(_ type: T.Type) -> Result<T, ProviderError> {
    let key = Key(type)
    return if let factory = factories[key] {
      // swiftlint:disable force_cast
      .success(factory() as! T)
      // swiftlint:enable force_cast
    } else {
      .failure(ProviderError(key: key.value))
    }
  }
  
  public func get<T>(_ type: T.Type = T.self) -> T {
    let key = Key(type)
    return if let factory = factories[key] {
      // swiftlint:disable force_cast
      factory() as! T
      // swiftlint:enable force_cast
    } else {
      fatalError("Key '\(key)' not registered. Registered types: \(factories.keys)")
    }
  }
}

public struct ProviderError: Error, Equatable {
  let key: String
}

@MainActor public func getProvider() -> Provider {
  Provider.instance ?? Provider.start()
}

private extension Provider {
  @MainActor static var instance: Provider?

  @MainActor static func start() -> Provider {
    if instance == nil {
      instance = Provider()
      return instance!
    } else {
      fatalError("Provider already initialized")
    }
  }
}
