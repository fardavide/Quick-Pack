import Combine
import QpUtils
import Undo

public protocol TripRepository: UndoHandler {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  @MainActor func saveTripMetadata(_ trip: Trip)
  @MainActor func markTripCompleted(tripId: TripId, isCompleted: Bool)
  @MainActor func addItem(_ item: TripItem, to tripId: TripId)
  @MainActor func updateItemCheck(_ itemId: TripItemId, isChecked: Bool)
  @MainActor func updateItemsOrder(sortedItems: [TripItem])
  @MainActor func removeItem(_ itemId: TripItemId, from tripId: TripId)
  @MainActor func deleteTrip(tripId: TripId)
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
  
  public func saveTripMetadata(_ trip: Trip) {
    saveTripInvocations.append(trip)
  }
  public func addItem(_ item: TripItem, to tripId: TripId) {}
  public func markTripCompleted(tripId: TripId, isCompleted: Bool) {}
  public func updateItemCheck(_ itemId: TripItemId, isChecked: Bool) {}
  public func updateItemsOrder(sortedItems: [TripItem]) {}
  public func removeItem(_ itemId: TripItemId, from tripId: TripId) {}
  public func deleteTrip(tripId: TripId) {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
