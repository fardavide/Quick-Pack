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
@inlinable public func waitNotNil<T>(_ value: () -> T?) async -> T {
  await waitFor { value() != nil }
  return value()!
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
