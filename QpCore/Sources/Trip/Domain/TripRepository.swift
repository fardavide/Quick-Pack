import Combine
import QpUtils
import Undo

public protocol TripRepository: UndoHandler {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  func saveTripMetadata(_ trip: Trip) async
  func addItem(_ item: TripItem, to tripId: TripId) async
  func updateItemCheck(_ itemId: TripItemId, isChecked: Bool) async
  func updateItemsOrder(sortedItems: [TripItem]) async
  func removeItem(_ itemId: TripItemId, from tripId: TripId) async
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
  
  public func saveTripMetadata(_ trip: Trip) async {
    saveTripInvocations.append(trip)
  }
  public func addItem(_ item: TripItem, to tripId: TripId) async {}
  public func updateItemCheck(_ itemId: TripItemId, isChecked: Bool) async {}
  public func updateItemsOrder(sortedItems: [TripItem]) async {}
  public func removeItem(_ itemId: TripItemId, from tripId: TripId) async {}
  public func deleteTrip(tripId: TripId) async {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
