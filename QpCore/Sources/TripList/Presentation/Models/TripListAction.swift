import TripDomain

public enum TripListAction {
  case deleteTrip(id: TripId)
  case newTrip
  case undoOrRedo
}
