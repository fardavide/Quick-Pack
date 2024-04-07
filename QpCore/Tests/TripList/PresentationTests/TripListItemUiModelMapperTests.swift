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
    #assert(result.date == nil)
  }
  
  @Test func whenExactDate_mapsCorrectly() {
    // given
    let trip = Trip(
      date: TripDate(value: todo),
      id: "trip",
      name: "Trip"
    )
    
    // when
    let result = mapper.toUiModel(trip: trip)
    
    // then
    #assert(result.date == nil)
  }
}
