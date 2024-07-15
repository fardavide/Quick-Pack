import DateUtils
import Provider
import TripDomain

public final class TripDataModule: Module {
  public init() {}
  
  public var dependencies = [
    DateUtilsModule.self
  ]
  
  public func register(on provider: Provider) {
    provider.register {
      RealTripRepository(
        container: provider.get(),
        getCurrentDate: provider.get()
      ) as TripRepository
    }
  }
}
