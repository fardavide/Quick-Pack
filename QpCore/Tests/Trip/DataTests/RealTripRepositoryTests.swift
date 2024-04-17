import Testing

import StorageModels
import SwiftData
import TripDomain
@testable import TripData

final class RealTripRepositoryTests {
  
  @Test func addTrip() async {
    // given
    let scenario = Scenario()
    
    // when
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip == .samples.malaysia.withoutItems())
  }
  
  @Test func updateTripDate() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip.samples.malaysia
    let updatedTrip = Trip(
      date: TripDate(year: 2025),
      id: initialTrip.id,
      isCompleted: false,
      items: initialTrip.items,
      name: initialTrip.name
    )
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    
    // when
    await scenario.sut.saveTripMetadata(updatedTrip)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.date == TripDate(year: 2025))
  }
  
  @Test func updateTripName() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip.samples.malaysia
    let updatedTrip = Trip(
      date: initialTrip.date,
      id: initialTrip.id,
      isCompleted: false,
      items: initialTrip.items,
      name: "New name"
    )
    
    // when
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    await scenario.sut.saveTripMetadata(updatedTrip)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.name == "New name")
  }
  
  @Test func addTripItem() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem.samples.camera
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    
    // when
    await scenario.sut.addItem(tripItem, to: trip.id)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.items == [tripItem])
  }
  
  @Test func addTripItem_withPreexistingName() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let preexistingTripItem = TripItem.samples.camera
    let newTripItem = TripItem.new(item: .new(name: preexistingTripItem.item.name))
    // craete trip
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    // crate item
    await scenario.sut.addItem(preexistingTripItem, to: trip.id)
    await scenario.sut.removeItem(preexistingTripItem.id, from: trip.id)
    
    // when
    await scenario.sut.addItem(newTripItem, to: trip.id)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.items.map(\.item) == [preexistingTripItem.item])
  }
  
  @Test func removeTripItem() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem.samples.camera
    
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrip = await scenario.firstSavedTrip()
    #expect(initialTrip?.items == [tripItem])
    
    // when
    await scenario.sut.removeItem(tripItem.id, from: trip.id)
    
    // then
    let updatedTrip = await scenario.firstSavedTrip()
    #expect(updatedTrip?.items == [])
  }
  
  @Test func updateTripItemCheck() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem.samples.camera
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrips = await scenario.sut.trips.waitFirst()
    #expect(initialTrips.orNil()?.first?.items.first?.isChecked == false)
    
    // when
    await scenario.sut.updateItemCheck(tripItem.id, isChecked: true)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.items.first?.isChecked == true)
  }
  
  @Test func updateTripItemsOrder() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let initialTripItems = [
      TripItem.samples.camera.withOrder(0),
      TripItem.samples.iPad.withOrder(1),
      TripItem.samples.nintendoSwitch.withOrder(2)
    ]
    let reorderedTripItems = [
      TripItem.samples.iPad.withOrder(1),
      TripItem.samples.nintendoSwitch.withOrder(2),
      TripItem.samples.camera.withOrder(0)
    ]
    let expectedTripItems = [
      TripItem.samples.iPad.withOrder(0),
      TripItem.samples.nintendoSwitch.withOrder(1),
      TripItem.samples.camera.withOrder(2)
    ]
    await scenario.sut.saveTripMetadata(.samples.malaysia.withoutItems())
    for tripItem in initialTripItems.reversed() {
      await scenario.sut.addItem(tripItem.withOrder(0), to: trip.id)
    }
    let initialTrips = await scenario.sut.trips.waitFirst()
    #expect(initialTrips.orNil()?.first?.items == initialTripItems)
    
    // when
    await scenario.sut.updateItemsOrder(sortedItems: reorderedTripItems)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.items == expectedTripItems)
  }
  
  @Test func pastTripsAreMarkedAsCompleted() async {
    // given
    let scenario = Scenario()
    let trip = Trip(
      date: TripDate(year: 2023, month: .oct),
      id: .samples.tunisia,
      isCompleted: false,
      items: [],
      name: Trip.samples.tunisia.name
    )
    await scenario.sut.saveTripMetadata(trip)
    
    // when
    await scenario.sut.sanitiseItems()

    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.isCompleted == true)
  }
}

private final class Scenario {
  
  let sut: RealTripRepository
  
  init() {
    do {
      let container = try ModelContainer(
        for: TripSwiftDataModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      sut = RealTripRepository(container: container)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func firstSavedTrip() async -> Trip? {
    await sut.trips.waitFirst().orNil()?.first
  }
}
