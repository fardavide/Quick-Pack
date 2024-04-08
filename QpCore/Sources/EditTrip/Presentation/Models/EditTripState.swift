import TripDomain

struct EditTripState {
  var date: TripDate?
  let id: TripId?
  var name: String
}

extension EditTripState {
  var trip: Trip {
    Trip(
      date: date,
      id: id ?? .new(),
      name: name
    )
  }
}

extension EditTripState {
  static let initial = EditTripState(
    date: nil,
    id: nil,
    name: ""
  )
  static let samples = EditTripStateSamples()
}

final class EditTripStateSamples {
  
}
