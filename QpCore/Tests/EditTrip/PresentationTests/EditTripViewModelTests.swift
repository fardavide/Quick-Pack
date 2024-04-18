import Testing

import DateUtils
import Foundation
import TripDomain
@testable import EditTripPresentation

final class EditTripViewModelTests {
  
  @Test func saveTripName() async {
    // given
    let scenario = Scenario()
    
    // when
    scenario.sut.send(.updateName(newName: "New name"))
    
    // then
    let savedTrip = await scenario.tripRepository.waitLastCreatedTrip()
    #expect(savedTrip.name == "New name")
  }
  
  @Test func savePreciseTripDate() async {
    // given
    let scenario = Scenario()
    
    // when
    scenario.sut.send(.updateDate(newDate: Date.of(year: 2024, month: .oct, day: 15)))
    
    // then
    let savedTrip = await scenario.tripRepository.waitLastCreatedTrip()
    #expect(savedTrip.date?.value == Date.of(year: 2024, month: .oct, day: 15))
    #expect(savedTrip.date?.precision == .exact)
  }
}

private final class Scenario {
  
  let sut: EditTripViewModel
  let tripRepository: FakeTripRepository
  
  init(
    initialTrip: Trip = .samples.malaysia,
    tripRepository: FakeTripRepository = FakeTripRepository()
  ) {
    self.tripRepository = tripRepository
    sut = EditTripViewModel(
      initialTrip: initialTrip,
      tripRepository: tripRepository
    )
  }
}
