import Testing

@testable import TripDomain

final class TripTests {
  
  @Test func comparable_considersDatesFirst() {
    let baseTrip = Trip.samples.malaysia
    #expect(baseTrip.withDate(TripDate(year: 2024)) > baseTrip.withDate(TripDate(year: 2023)))
    #expect(baseTrip.withDate(TripDate(year: 2024)) > baseTrip.withDate(nil))
  }
  
  @Test func comparable_considersNamesIfSameDate() {
    let baseTrip = Trip.samples.malaysia
    let date = TripDate(year: 2024)
    #expect(baseTrip.withName("b") > baseTrip.withName("a"))
    #expect(baseTrip.withName("b") < baseTrip.withName("c"))
  }
}
