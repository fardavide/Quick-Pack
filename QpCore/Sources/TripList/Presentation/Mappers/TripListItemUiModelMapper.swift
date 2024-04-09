import Foundation
import TripDomain

/// Converts `Trip` to `TripListItemUiModel`
protocol TripListItemUiModelMapper {
  func toUiModel(trip: Trip) -> TripListItemUiModel
}

extension TripListItemUiModelMapper {
  func toUiModels(trips: [Trip]) -> [TripListItemUiModel] {
    trips.map(toUiModel)
  }
}

final class RealTripListItemUiModelMapper: TripListItemUiModelMapper {
  
  func toUiModel(trip: Trip) -> TripListItemUiModel {
    TripListItemUiModel(
      date: mapDate(trip.date),
      domainModel: trip,
      id: trip.id,
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

extension TripListItemUiModelMapper {
  static var fake: TripListItemUiModelMapper {
    FakeTripListItemUiModelMapper()
  }
}

final class FakeTripListItemUiModelMapper: TripListItemUiModelMapper {
  private let real = RealTripListItemUiModelMapper()
  func toUiModel(trip: Trip) -> TripListItemUiModel {
    real.toUiModel(trip: trip)
  }
}
