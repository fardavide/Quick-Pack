import Testing

@testable import TripDomain

final class TripDateTests {
  
  @Test func whenExactDate_longFormatted() {
    let date = TripDate(year: 2024, month: .dec, day: 24)
    #expect(date.longFormatted == "24 December 2024")
  }
  
  @Test func whenMonthPrecisionDate_longFormatted() {
    let date = TripDate(year: 2024, month: .oct)
    #expect(date.longFormatted == "October 2024")
  }
  
  @Test func whenYearPrecisionDate_longFormatted() {
    let date = TripDate(year: 2025)
    #expect(date.longFormatted == "2025")
  }
  
  @Test func whenExactDate_shortFormatted() {
    let date = TripDate(year: 2024, month: .dec, day: 24)
    #expect(date.shortFormatted == "24 Dec 2024")
  }
  
  @Test func whenMonthPrecisionDate_shortFormatted() {
    let date = TripDate(year: 2024, month: .oct)
    #expect(date.shortFormatted == "Oct 2024")
  }
  
  @Test func whenYearPrecisionDate_shortFormatted() {
    let date = TripDate(year: 2025)
    #expect(date.shortFormatted == "2025")
  }
}
