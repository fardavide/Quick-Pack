import Foundation

public enum Month: CaseIterable, Identifiable {
  case jan
  case feb
  case mar
  case apr
  case may
  case jun
  case jul
  case aug
  case sep
  case oct
  case nov
  case dec
  
  public var id: Month {
    self
  }
}

extension Month {
  static func from(_ number: Int) -> Month {
    if let result = allCases.first(where: { $0.ordinal() == number - 1 }) { 
      result
    } else {
      fatalError("Cannot get month from \(number)")
    }
  }
  
  public func ordinal() -> Self.AllCases.Index {
    Self.allCases.firstIndex(of: self)!
  }
}
