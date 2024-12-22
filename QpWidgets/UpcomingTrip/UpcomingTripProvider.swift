import DateUtils
import Provider
import QpUtils
import TripDomain
import TripPresentation
import WidgetKit

final class UpcomingTripProvider: AppIntentTimelineProvider {
  private let buildCountdownText: BuildCountdownText
  private let buildItemsText: BuildItemsText
  private let tripRepository: TripRepository
  
  @MainActor
  init() {
    let provider = getProvider()
    buildCountdownText = provider.get()
    buildItemsText = provider.get()
    tripRepository = provider.get()
  }
  
  func placeholder(in context: Context) -> UpcomingTripEntry {
    .placeholder
  }
  
  func snapshot(
    for configuration: UpcomingTripIntent,
    in context: Context
  ) async -> UpcomingTripEntry {
    UpcomingTripEntry(
      date: .now,
      model: await tripRepository.getNextTrip()
        .toModel(
          buildCountdownText: buildCountdownText,
          buildItemsText: buildItemsText
        )
        .orPlaceholder
    )
  }
  
  func timeline(
    for configuration: UpcomingTripIntent,
    in context: Context
  ) async -> Timeline<UpcomingTripEntry> {
    let date = Date.now
    let entry = UpcomingTripEntry(
      date: date,
      model: await tripRepository.getNextTrip()
        .toModel(
          buildCountdownText: buildCountdownText,
          buildItemsText: buildItemsText
        )
    )
    return Timeline(
      entries: [entry],
      policy: .after(date + 15.minutes())
    )
  }
}

private extension Result<Trip?, DataError> {
  func toModel(
    buildCountdownText: BuildCountdownText,
    buildItemsText: BuildItemsText
  ) -> UpcomingTripWidgetModel {
    switch self {
    case .success(.some(let trip)): .some(
      UpcomingTripModel(
        id: trip.id,
        name: trip.name,
        countdown: buildCountdownText.run(to: trip.date),
        items: buildItemsText.run(trip.items)
      )
    )
    case .success(.none): .none
    case .failure(let error): .error(error)
    }
  }
}

private extension UpcomingTripWidgetModel {
  var orPlaceholder: UpcomingTripWidgetModel {
    switch self {
    case .some: self
    case .none: .placeholder
    case .error: .placeholder
    }
  }
}
