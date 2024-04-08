import Foundation

public struct Trip: Equatable {
  public let date: TripDate?
  public let id: TripId
  public let name: String
  
  public init(
    date: TripDate?,
    id: TripId,
    name: String
  ) {
    self.date = date
    self.id = id
    self.name = name
  }
}
