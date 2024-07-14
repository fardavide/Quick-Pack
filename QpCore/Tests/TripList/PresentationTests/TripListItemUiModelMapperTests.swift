import Testing

import TripDomain

@testable import TripListPresentation

final class TripListItemUiModelMapperTests {
  
  private let mapper = RealTripListUiModelMapper()
  
  @Test func whenNoDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: nil,
      id: TripId("trip"),
      isCompleted: false,
      items: [],
      name: "Trip",
      reminder: nil
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
      id: TripId("xmas"),
      isCompleted: false,
      items: [],
      name: "Xmas holidays",
      reminder: nil
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
      id: TripId("malaysia"),
      isCompleted: false,
      items: [],
      name: "Malaysia",
      reminder: nil
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
      id: TripId("summer"),
      isCompleted: false,
      items: [],
      name: "Summer",
      reminder: nil
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #expect(result.date == "2025")
  }
}
