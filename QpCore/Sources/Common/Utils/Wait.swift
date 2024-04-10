import Combine
import Foundation

/// Wait till `condition` is satisfied (returns `true`)
public func waitFor(
  _ condition: () -> Bool,
  timeout: Duration? = nil
) async {
  let timeout = timeout ?? defaultTimeout
  let startTime = Date.now
  let timedOut: () -> Bool = {
    let currentTime = Date.now
    return currentTime > (startTime + timeout)
  }
  repeat {
    do {
      try await Task.sleep(for: loopDuration)
    } catch {
      fatalError(error.localizedDescription)
    }
  } while !timedOut() && !condition()
}

/// Wait till `value` produces a non-nil value
/// - Returns: non `nill` result of `value`
@inlinable public func waitNonNil<T>(_ value: () -> T?) async -> T {
  await waitFor { value() != nil }
  return value()!
}

public extension Publisher {
  
  /// Wait till the `Publisher` emits its first value
  /// - Returns: the value
  func waitFirst() async -> Output {
    var result: Output?
    var cancellables: [AnyCancellable] = []
    let cancellable = sink(
      receiveCompletion: { _ in cancellables.forEach { c in c.cancel() } },
      receiveValue: { value in result = value }
    )
    cancellables.append(cancellable)
    return await waitNonNil { result }
  }
}

private let defaultTimeout = Duration.seconds(3)
private let loopDuration = Duration.milliseconds(5)

private extension Date {
  
  static func + (lhs: Date, rhs: Duration) -> Date {
    let initialInterval = lhs.timeIntervalSince1970
    let finalInterval = initialInterval + rhs.secondsInterval
    return Date(timeIntervalSince1970: finalInterval)
  }
}

private extension Duration {
  var secondsInterval: Double {
    let v = components
    return Double(v.seconds) + Double(v.attoseconds) * 1e-12
  }
}
