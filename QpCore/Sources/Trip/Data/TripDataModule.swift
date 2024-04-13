import Provider
import TripDomain

public final class TripDataModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register { RealTripRepository(context: provider.get()) as TripRepository }
  }
}
