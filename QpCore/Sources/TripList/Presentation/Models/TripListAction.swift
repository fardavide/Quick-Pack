import TripDomain

public enum TripListAction {
  case delete(id: TripId)
  case markCompleted(id: TripId)
  case markNotCompleted(id: TripId)
  case newTrip
}
