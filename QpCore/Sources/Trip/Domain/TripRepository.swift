import Combine
import QpUtils

public protocol TripRepository {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  func saveTrip(_ trip: Trip) async
  func saveItem(_ tripItem: TripItem) async
  func deleteTrip(tripId: TripId) async
}

public final class FakeTripRepository: TripRepository {
  public var trips: any DataPublisher<[Trip]>
  private var saveTripInvocations: [Trip] = []
  
  public init(
    trips: [Trip] = []
  ) {
    self.trips = Just(.success(trips))
  }
  
  public func lastSavedTrip() -> Trip? {
    saveTripInvocations.last
  }
  
  public func waitLastSavedTrip() async -> Trip {
    await waitNonNil { lastSavedTrip() }
  }
  
  public func saveTrip(_ trip: Trip) async {
    saveTripInvocations.append(trip)
  }
  public func saveItem(_ tripItem: TripItem) async {}
  public func deleteTrip(tripId: TripId) async {}
}
