import DateUtils
import Provider
import QpUtils
import TripDomain
import WidgetKit

public final class UpcomingTripsProvider: AppIntentTimelineProvider {
  private let tripRepository: TripRepository
  
  @MainActor
  public init() {
    tripRepository = getProvider().get()
  }
  
  public func placeholder(in context: Context) -> UpcomingTripsEntry {
    UpcomingTripsEntry(date: .now, trips: .placeholders)
  }
  
  public func snapshot(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> UpcomingTripsEntry {
    UpcomingTripsEntry(date: .now, trips: await tripsOrEmpty().ifEmpty(.placeholders))
  }
  
  public func timeline(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> Timeline<UpcomingTripsEntry> {
    let date = Date.now
    let entry = UpcomingTripsEntry(date: date, trips: await tripsOrEmpty())
    let nextUpdateDate = date + 15.minutes()
    
    return Timeline(
      entries: [entry],
      policy: .after(nextUpdateDate)
    )
  }
  
  private func tripsOrEmpty() async -> [UpcomingTripModel] {
    await tripRepository.getTrips().fold { trips in
      trips.map { trip in UpcomingTripModel(name: trip.name, date: trip.date) }
    } onFailure: { _ in
      []
    }
  }
}
