import TripDomain

public struct EditTripState {
  var date: TripDate?
  var id: TripId
  var name: String
}

extension Trip {
  func toEditTripState() -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      name: name
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
}

final class EditTripStateSamples {
  let malaysia = Trip.samples.malaysia.toEditTripState()
}
