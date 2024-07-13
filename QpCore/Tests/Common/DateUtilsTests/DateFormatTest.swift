import Foundation
import Testing

@testable import DateUtils

struct DateFormatTest {
  
  @Test func date_of_with_time() {
    let date = Date.of(
      year: 2024,
      month: .aug,
      day: 20,
      hour: 15,
      minute: 30,
      second: 10
    )
    #expect(date.formatted() == "20/08/2024, 15:30")
  }
  
  @Test func date_of_without_time() {
    let date = Date.of(year: 2024, month: .nov, day: 1)
    #expect(date.formatted() == "01/11/2024, 0:00")
  }
}
