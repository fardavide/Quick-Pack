import Foundation

public extension Date {
  
  var day: Int {
    self.get(.day)
  }
  
  var month: Month {
    Month.from(self.get(.month))
  }
  
  var year: Int {
    self.get(.year)
  }
  
  var daysThisMonth: Int {
    calendar.range(of: .day, in: .month, for: self)!.count
  }
  
  func withDay(_ day: Int) -> Date {
    Date.of(year: year, month: month, day: day)
  }
  
  func withMonth(_ month: Month) -> Date {
    Date.of(year: year, month: month, day: day)
  }
  
  func withYear(_ year: Int) -> Date {
    Date.of(year: year, month: month, day: day)
  }
}

private var calendar: Calendar {
  Calendar.current
}

extension Date {

  func get(_ components: Calendar.Component...) -> DateComponents {
    calendar.dateComponents(Set(components), from: self)
  }
  
  func get(_ component: Calendar.Component) -> Int {
    calendar.component(component, from: self)
  }
}
