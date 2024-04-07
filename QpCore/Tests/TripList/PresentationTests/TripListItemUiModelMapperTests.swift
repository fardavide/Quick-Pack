import Testing

import TripDomain

@testable import TripListPresentation

final class TripListItemUiModelMapperTests {
  
  private let mapper = RealTripListItemUiModelMapper()
  
  @Test func whenNoDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: nil,
      id: "trip",
      name: "Trip"
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #expect(result.date == nil)
  }
  
  @Test func whenExactDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: TripDate(year: 2024, month: .dec, day: 24),
      id: "xmas",
      name: "Xmas holidays"
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #expect(result.date == "24 December 2024")
  }
  
  @Test func whenMonthPrecisionDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: TripDate(year: 2024, month: .oct),
      id: "malaysia",
      name: "Malaysia"
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #expect(result.date == "October 2024")
  }
  
  @Test func whenYearPrecisionDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: TripDate(year: 2025),
      id: "summer",
      name: "Summer"
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #expect(result.date == "2025")
  }
}
