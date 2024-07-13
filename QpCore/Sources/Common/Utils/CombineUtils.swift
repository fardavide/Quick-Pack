import Combine
import Foundation

public typealias SafePublisher<T> = Publisher<T, Never>
public typealias DataPublisher<Data> = Publisher<Result<Data, DataError>, Never>

public extension Publisher {
  
  func filterSuccess<T>() -> Publishers.CompactMap<Self, T> where Output == Result<T, DataError> {
    compactMap { $0.orNil() }
  }
}

public extension Timer {
  
  /// Returns a publisher that repeatedly emits a value `T` on the given interval.
  ///
  /// - Parameters:
  ///   - interval: The time interval on which to publish events. For example, a value of `0.5` publishes an event 
  ///     approximately every half-second.
  ///   - tolerance: The allowed timing variance when emitting events. Defaults to `nil`, which allows any variance.
  ///   - runLoop: The run loop on which the timer runs.
  ///   - mode: The run loop mode in which to run the timer.
  ///   - options: Scheduler options passed to the timer. Defaults to `nil`.
  ///   - value: A closure that returns a value `T`
  /// - Returns: A publisher that repeatedly emits a value `T` on the given interval.
  @inlinable static func publish<T>(
    every interval: TimeInterval,
    tolerance: TimeInterval? = nil,
    on runLoop: RunLoop,
    in mode: RunLoop.Mode,
    options: RunLoop.SchedulerOptions? = nil,
    _ value: @Sendable @escaping () -> T
  ) -> Publishers.FlatMap<Just<T>, Publishers.Autoconnect<Timer.TimerPublisher>> {
    publish(every: interval, tolerance: tolerance, on: runLoop, in: mode, options: options)
      .autoconnect()
      .flatMap { _ in
        Just(value())
      }
  }
}
