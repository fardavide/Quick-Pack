import DateUtils
import Foundation
import Provider
import QpUtils
import TripDomain
import WidgetKit

final class UpcomingTripProvider: AppIntentTimelineProvider {
  private let tripRepository: TripRepository
  
  @MainActor
  init() {
    tripRepository = getProvider().get()
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
      model: await tripRepository.getNextTrip().toModel().orPlaceholder
    )
  }
  
  func timeline(
    for configuration: UpcomingTripIntent,
    in context: Context
  ) async -> Timeline<UpcomingTripEntry> {
    let date = Date.now
    let entry = UpcomingTripEntry(
      date: date,
      model: await tripRepository.getNextTrip().toModel()
    )
    return Timeline(
      entries: [entry],
      policy: .after(date + 15.minutes())
    )
  }
}

private extension Result<Trip?, DataError> {
  func toModel() -> UpcomingTripWidgetModel {
    switch self {
    case .success(.some(let trip)): .some(
      UpcomingTripModel(
        name: trip.name,
        countdown: countdownText(to: trip.date),
        items: itemsText(trip.items)
      )
    )
    case .success(.none): .none
    case .failure(let error): .error(error)
    }
  }
  
  private func countdownText(to date: TripDate?) -> String {
    let now = Date.now
    switch (date?.precision, date?.value) {
    case (.exact?, let value?):
      let daysDiff = daysDiff(to: value)
      return switch daysDiff {
      case 0: "Today"
      case 1: "Tomorrow"
      default: "In \(daysDiff) days"
      }
    case (.month?, let value?):
      let monthsDiff = monthsDiff(to: value)
      return switch monthsDiff {
      case 0: "This month"
      case 1: "Next month"
      default: "In \(monthsDiff) months"
      }
    case (.year?, let value?):
      return switch value.year {
      case now.year: "This year"
      case now.year + 1: "Next year"
      default: "In \(value.year - now.year) years"
      }
    default: return "No date"
    }
  }
  
  private func itemsText(_ items: [TripItem]) -> String {
    if items.isEmpty {
      "No items"
    } else {
      "\(items.filter(\.isChecked).count) / \(items.count) items packed"
    }
  }
  
  private func daysDiff(to date: Date) -> Int {
    Calendar.current.dateComponents(
      [.day],
      from: Calendar.current.startOfDay(for: Date.now),
      to: date
    ).day ?? 0
  }
  
  private func monthsDiff(to date: Date) -> Int {
    Calendar.current.dateComponents(
      [.month],
      from: Calendar.current.startOfDay(for: Date.now),
      to: date
    ).month ?? 0
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
