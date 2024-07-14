import Testing

import CategoryDomain
import DateUtils
import Foundation
import ItemDomain
import QpUtils
import TripDomain
@testable import EditTripPresentation

final class EditTripViewModelTests {
  
  @Test func saveTripName() async {
    // given
    let scenario = Scenario(
      initialTrip: .samples.malaysia
    )
    
    // when
    await scenario.sut.send(.updateName("New name"))
    
    // then
    let last = await scenario.tripRepository.waitlastUpdateTripName()
    #expect(last == (.samples.malaysia, "New name"))
  }
  
  @Test func savePreciseTripDate() async {
    // given
    let scenario = Scenario(
      initialTrip: .samples.malaysia
    )
    
    // when
    await scenario.sut.send(.updateDate(TripDate(year: 2024, month: .oct, day: 15)))
    
    // then
    let last = await scenario.tripRepository.waitlastUpdateTripDate()
    #expect(last == (.samples.malaysia, TripDate(year: 2024, month: .oct, day: 15)))
  }
}

private final class Scenario: @unchecked Sendable {
  
  let sut: EditTripViewModel
  let tripRepository: FakeTripRepository
  
  init(
    initialTrip: Trip = .samples.malaysia,
    categoryRepository: CategoryRepository = FakeCategoryRepository(),
    itemRepository: ItemRepository = FakeItemRepository(),
    tripRepository: FakeTripRepository = FakeTripRepository()
  ) {
    self.tripRepository = tripRepository
    sut = EditTripViewModel(
      initialTrip: initialTrip,
      categoryRepository: categoryRepository,
      itemRepository: itemRepository,
      tripRepository: tripRepository
    )
  }
}
