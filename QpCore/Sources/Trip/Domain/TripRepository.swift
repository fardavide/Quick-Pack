import Combine
import Foundation
import QpUtils
import Undo

public protocol TripRepository: UndoHandler {
  
  var trips: any DataPublisher<[Trip]> { get }
  
  @MainActor func createTrip(_ trip: Trip)
  @MainActor func updateTripName(tripId: TripId, name: String)
  @MainActor func updateTripDate(tripId: TripId, date: TripDate?)
  @MainActor func markTripCompleted(tripId: TripId, isCompleted: Bool)
  @MainActor func updateReminder(tripId: TripId, reminder: Date?)
  @MainActor func deleteTrip(tripId: TripId)
  
  @MainActor func addItem(_ item: TripItem, to tripId: TripId)
  @MainActor func updateItemCheck(tripItemId: TripItemId, isChecked: Bool)
  @MainActor func updateItemNotes(tripItemId: TripItemId, notes: String)
  @MainActor func updateItemsOrder(sortedItems: [TripItem])
  @MainActor func removeItem(itemId: TripItemId, from tripId: TripId)
  
  @MainActor func cleanUp()
}

public final class FakeTripRepository: TripRepository {
  public var trips: any DataPublisher<[Trip]>
  public private(set) var createTrip: [Trip] = []
  public private(set) var updateReminder: [(TripId, Date?)] = []
  public private(set) var updateTripName: [(TripId, newName: String)] = []
  public private(set) var updateTripDate: [(TripId, TripDate?)] = []
  
  public init(
    trips: [Trip] = []
  ) {
    self.trips = Just(.success(trips))
  }
  
  // MARK: utils
  public func waitLastCreateTrip() async -> Trip? {
    await waitNonNil { createTrip.last }
  }
  public func waitLastUpdateReminder() async -> (TripId, Date?) {
    await waitNonNil { updateReminder.last }
  }
  public func waitlastUpdateTripName() async -> (TripId, newName: String) {
    await waitNonNil { updateTripName.last }
  }
  public func waitlastUpdateTripDate() async -> (TripId, TripDate?) {
    await waitNonNil { updateTripDate.last }
  }
  
  // MARK: overrides
  public func createTrip(_ trip: Trip) {
    createTrip.append(trip)
  }
  public func updateTripName(tripId: TripId, name: String) {
    updateTripName.append((tripId, name))
  }
  public func updateTripDate(tripId: TripId, date: TripDate?) {
    updateTripDate.append((tripId, date))
  }
  public func markTripCompleted(tripId: TripId, isCompleted: Bool) {}
  public func updateReminder(tripId: TripId, reminder: Date?) {
    updateReminder.append((tripId, reminder))
  }
  public func deleteTrip(tripId: TripId) {}
  
  public func addItem(_ item: TripItem, to tripId: TripId) {}
  public func updateItemCheck(tripItemId: TripItemId, isChecked: Bool) {}
  public func updateItemNotes(tripItemId: TripItemId, notes: String) {}
  public func updateItemsOrder(sortedItems: [TripItem]) {}
  public func removeItem(itemId: TripItemId, from tripId: TripId) {}
  
  public func requestUndoOrRedo() -> Undo.UndoHandle? {
    nil
  }
  
  public func cleanUp() {}
}
