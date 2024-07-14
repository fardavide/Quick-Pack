import Provider

public final class NotificationsModule: Module {
  public init() {}
  
  public func register(on provider: Provider) {
    provider
      .register {
        RealScheduleReminders(tripRepository: provider.get()) as ScheduleReminders
      }
  }
}
