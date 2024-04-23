import Combine
import QpUtils
import Undo

public protocol TripRepository: UndoHandler {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  @MainActor func createTrip(_ trip: Trip)
  @MainActor func updateTripName(tripId: TripId, name: String)
  @MainActor func updateTripDate(tripId: TripId, date: TripDate?)
  @MainActor func markTripCompleted(tripId: TripId, isCompleted: Bool)
  @MainActor func deleteTrip(tripId: TripId)
  
  @MainActor func addItem(_ item: TripItem, to tripId: TripId)
  @MainActor func updateItemCheck(tripItemId: TripItemId, isChecked: Bool)
  @MainActor func updateItemNotes(tripItemId: TripItemId, notes: String)
  @MainActor func updateItemsOrder(sortedItems: [TripItem])
  @MainActor func removeItem(itemId: TripItemId, from tripId: TripId)
}

public final class FakeTripRepository: TripRepository {
  public var trips: any DataPublisher<[Trip]>
  private var createTripInvocations: [Trip] = []
  
  public init(
    trips: [Trip] = []
  ) {
    self.trips = Just(.success(trips))
  }
  
  public func lastCreatedTrip() -> Trip? {
    createTripInvocations.last
  }
  
  public func waitLastCreatedTrip() async -> Trip {
    await waitNonNil { lastCreatedTrip() }
  }
  
  public func createTrip(_ trip: Trip) {
    createTripInvocations.append(trip)
  }
  public func updateTripName(tripId: TripId, name: String) {}
  public func updateTripDate(tripId: TripId, date: TripDate?) {}
  public func markTripCompleted(tripId: TripId, isCompleted: Bool) {}
  public func deleteTrip(tripId: TripId) {}
  
  public func addItem(_ item: TripItem, to tripId: TripId) {}
  public func updateItemCheck(tripItemId: TripItemId, isChecked: Bool) {}
  public func updateItemNotes(tripItemId: TripItemId, notes: String) {}
  public func updateItemsOrder(sortedItems: [TripItem]) {}
  public func removeItem(itemId: TripItemId, from tripId: TripId) {}
  
  public func requestUndoOrRedo() -> Undo.UndoHandle? {
    nil
  }
}
