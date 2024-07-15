import Foundation

public protocol GetCurrentDate {
  
  func run() -> Date
}

public final class FakeGetCurrentDate: GetCurrentDate {
  private let date: Date
  
  public init(date: Date) {
    self.date = date
  }
  
  public func run() -> Date {
    date
  }
}

final class RealGetCurrentDate: GetCurrentDate {
  
  func run() -> Date {
    Date.now
  }
}
