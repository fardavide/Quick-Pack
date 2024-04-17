import Foundation
import TripDomain

/// Converts an `Array` of `Trip` to `TripListUiModel`
protocol TripListUiModelMapper {
  func toUiModel(trips: [Trip]) -> TripListUiModel
}

final class RealTripListUiModelMapper: TripListUiModelMapper {
  
  func toUiModel(trips: [Trip]) -> TripListUiModel {
    let allTrips = trips.map(toUiModel)
    return TripListUiModel(
      completed: allTrips.filter(\.isCompleted),
      upcoming: allTrips.filter { !$0.isCompleted }
    )
  }
  
  func toUiModel(trip: Trip) -> TripListItemUiModel {
    TripListItemUiModel(
      date: mapDate(trip.date),
      domainModel: trip,
      id: trip.id,
      isCompleted: trip.isCompleted,
      name: trip.name
    )
  }
  
  private func mapDate(_ tripDate: TripDate?) -> String? {
    switch tripDate?.precision {
    case nil: nil
    case .exact: tripDate!.value.formatted(date: .long, time: .omitted)
    case .month: tripDate!.value.formatted(dateFormat: "LLLL yyyy")
    case .year: tripDate!.value.formatted(dateFormat: "yyyy")
    }
  }
}

private extension Date {
  func formatted(dateFormat: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: self)
  }
}

extension TripListUiModelMapper {
  static var fake: TripListUiModelMapper {
    FakeTripListUiModelMapper()
  }
}

final class FakeTripListUiModelMapper: TripListUiModelMapper {
  private let real = RealTripListUiModelMapper()
  func toUiModel(trips: [Trip]) -> TripListUiModel {
    real.toUiModel(trips: trips)
  }
}
