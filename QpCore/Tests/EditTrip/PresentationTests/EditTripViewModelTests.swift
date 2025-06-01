import Testing

import CategoryDomain
import DateUtils
import Foundation
import ItemDomain
import Notifications
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
  
  @Test func updateReminder() async {
    // given
    let scenario = Scenario()
    let reminder = Date.of(year: 2024, month: .oct, day: 10, hour: 16)
    
    // when
    await scenario.sut.send(.updateReminder(reminder))
    
    // then
    let last = await scenario.tripRepository.waitLastUpdateReminder()
    #expect(last == (.samples.malaysia, reminder))
    #expect(scenario.scheduleReminders.didRun == true)
  }
  
  @Test func updateItemName() async {
    // given
    let scenario = Scenario()
    let itemId = ItemId.samples.camera
    let newName = "Updated Camera Name"
    
    // when
    await scenario.sut.send(.updateItemName(itemId, newName))
    
    // then
    let last = await scenario.itemRepository.waitLastUpdateItemName()
    #expect(last == (itemId: itemId, name: newName))
  }
  
  @Test func updateItemNameClearsRequest() async {
    // given
    let scenario = Scenario()
    let tripItem = TripItem.samples.camera
    let newName = "Updated Camera Name"
    
    // Set a rename request first
    await scenario.sut.send(.handleRequest(.showRename(item: tripItem, name: tripItem.item.name)))
    #expect(scenario.sut.state.request != nil)
    
    // when
    await scenario.sut.send(.updateItemName(tripItem.item.id, newName))
    
    // then
    #expect(scenario.sut.state.request == nil)
  }
}

private final class Scenario: @unchecked Sendable {
  
  let sut: EditTripViewModel
  let scheduleReminders: FakeScheduleReminders
  let tripRepository: FakeTripRepository
  let itemRepository: FakeItemRepository
  
  init(
    initialTrip: Trip = .samples.malaysia,
    categoryRepository: CategoryRepository = FakeCategoryRepository(),
    itemRepository: FakeItemRepository = FakeItemRepository(),
    scheduleReminders: FakeScheduleReminders = FakeScheduleReminders(),
    tripRepository: FakeTripRepository = FakeTripRepository()
  ) {
    self.scheduleReminders = scheduleReminders
    self.tripRepository = tripRepository
    self.itemRepository = itemRepository
    sut = EditTripViewModel(
      initialTrip: initialTrip,
      categoryRepository: categoryRepository,
      itemRepository: itemRepository,
      scheduleRemindersTask: scheduleReminders,
      tripRepository: tripRepository
    )
  }
}
