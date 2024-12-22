import DateUtils
import Foundation
import TripDomain

public protocol BuildCountdownText {
  func run(to date: TripDate?) -> String
}

final class RealBuildCountdownText: BuildCountdownText {
  private let getCurrentDate: GetCurrentDate
  
  init (getCurrentDate: GetCurrentDate) {
    self.getCurrentDate = getCurrentDate
  }
  
  func run(to date: TripDate?) -> String {
    let now = getCurrentDate.run()
    switch (date?.precision, date?.value) {
    case (.exact?, let value?):
      let daysDiff = daysDiff(now: now, to: value)
      return switch daysDiff {
      case 0: "Today"
      case 1: "Tomorrow"
      case -1: "Yesterday"
      case ..<0: "\(-daysDiff) days ago"
      default: "In \(daysDiff) days"
      }
    case (.month?, let value?):
      let monthsDiff = monthsDiff(now: now, to: value)
      return switch monthsDiff {
      case 0: "This month"
      case 1: "Next month"
      case -1: "Last month"
      case ..<0: "\(-monthsDiff) months ago"
      default: "In \(monthsDiff) months"
      }
    case (.year?, let value?):
      let yearsDiff = value.year - now.year
      return switch yearsDiff {
      case 0: "This year"
      case 1: "Next year"
      case -1: "Last year"
      case ..<0: "\(-yearsDiff) years ago"
      default: "In \(yearsDiff) years"
      }
    default: return "No date"
    }
  }

  private func daysDiff(now: Date, to date: Date) -> Int {
    let calendar = Calendar.current
    let nowStart = calendar.startOfDay(for: now)
    let dateStart = calendar.startOfDay(for: date)
    
    let components = calendar.dateComponents([.day], from: nowStart, to: dateStart)
    return components.day ?? 0
  }

  private func monthsDiff(now: Date, to date: Date) -> Int {
    let calendar = Calendar.current
    
    // Start of month for both dates
    let nowComponents = calendar.dateComponents([.year, .month], from: now)
    let dateComponents = calendar.dateComponents([.year, .month], from: date)
    
    let yearDiff = dateComponents.year! - nowComponents.year!
    let monthDiff = dateComponents.month! - nowComponents.month!
    
    return yearDiff * 12 + monthDiff
  }
}
