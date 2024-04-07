import Foundation

public enum Month: CaseIterable {
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
}

extension Month {
  
  public func ordinal() -> Self.AllCases.Index {
    return Self.allCases.firstIndex(of: self)!
  }
}
