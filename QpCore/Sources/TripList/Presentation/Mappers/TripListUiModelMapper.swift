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
      date: trip.date?.longFormatted,
      domainModel: trip,
      id: trip.id,
      isCompleted: trip.isCompleted,
      name: trip.name
    )
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
