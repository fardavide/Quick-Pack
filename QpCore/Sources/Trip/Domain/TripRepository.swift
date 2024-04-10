import Combine
import QpUtils

public protocol TripRepository {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  func deleteTrip(tripId: TripId) async
  func saveTrip(_ trip: Trip) async
}

public final class FakeTripRepository: TripRepository {
  public var trips: any DataPublisher<[Trip]>
  public var saveTripInvocations: [Trip] = []
  
  public init(
    trips: [Trip] = []
  ) {
    self.trips = Just(.success(trips))
  }
  
  public func lastSavedTrip() -> Trip? {
    saveTripInvocations.last
  }
  
  public func waitLastSavedTrip() async -> Trip {
    await waitNotNil { lastSavedTrip() }
  }
  
  public func deleteTrip(tripId: TripId) async {}
  public func saveTrip(_ trip: Trip) async {
    saveTripInvocations.append(trip)
  }
}
