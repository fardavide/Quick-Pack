import TripDomain

enum EditTripRequest {
  case showRename(_ tripItem: TripItem)
  case showSetCategory(_ tripItem: TripItem)
  case showSetNotes(_ tripItem: TripItem)
}
