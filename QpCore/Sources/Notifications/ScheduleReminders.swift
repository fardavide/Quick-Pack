import DateUtils
import Foundation
import TripDomain
import UserNotifications

public protocol ScheduleReminders {
  
  func run()
}

public final class FakeScheduleReminders: ScheduleReminders {
  public init() {}
  
  public func run() {}
}

public final class RealScheduleReminders: ScheduleReminders, @unchecked Sendable {

  private let tripRepository: TripRepository
  
  init(tripRepository: TripRepository) {
    self.tripRepository = tripRepository
  }

  public func run() {
    Task {
      let center = UNUserNotificationCenter.current()
      guard let trips = await tripRepository.trips.waitFirst().orNil() else { return }
      center.removePendingNotificationRequests(
        withIdentifiers: trips.filter { $0.reminder == nil }.map { $0.id.value }
      )
      
      for trip in trips where trip.reminder != nil {
        let reminder = trip.reminder!
        let content = UNMutableNotificationContent()
        content.title = trip.name
        content.subtitle = "Remember to pack your things!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: .init(
            year: reminder.year,
            month: reminder.monthInt,
            day: reminder.day,
            hour: reminder.hour,
            minute: reminder.minute
          ),
          repeats: false
        )
        
        let request = UNNotificationRequest(identifier: trip.id.value, content: content, trigger: trigger)
        do {
          try await center.add(request)
        } catch {
          print(error)
        }
      }
    }
  }
}
