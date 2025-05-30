@testable import TripData

import DateUtils
import Foundation
import StorageModels
import SwiftData
import Testing
import TripDomain

final class RealTripRepositoryTests {
  
  @Test func addTrip() async {
    // given
    let scenario = Scenario()
    
    // when
    await scenario.sut.createTrip(.samples.malaysia.withoutItems())
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip == .samples.malaysia.withoutItems())
  }
  
  @Test func updateTripDate() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    await scenario.sut.createTrip(trip)
    
    // when
    await scenario.sut.updateTripDate(tripId: trip.id, date: TripDate(year: 2025))
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.date == TripDate(year: 2025))
  }
  
  @Test func updateTripName() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    await scenario.sut.createTrip(trip)
    
    // when
    await scenario.sut.updateTripName(tripId: trip.id, name: "New name")
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.name == "New name")
  }
  
  @Test func whenPastTripIsMarkedAsNotCompleted_dateIsRemoved() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.tunisia
    await scenario.sut.createTrip(trip.withoutItems())
    
    // when
    await scenario.sut.markTripCompleted(tripId: trip.id, isCompleted: false)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.date == nil)
  }
  
  @Test func addTripItem() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem.samples.camera.withoutCategory().withUsageCount(1)
    await scenario.sut.createTrip(trip.withoutItems())
    
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
    let preexistingTripItem = TripItem.samples.camera.withoutCategory().withUsageCount(1)
    let newTripItem = TripItem.new(item: .new(name: preexistingTripItem.item.name))
    // craete trip
    await scenario.sut.createTrip(trip.withoutItems())
    // crate item
    await scenario.sut.addItem(preexistingTripItem, to: trip.id)
    await scenario.sut.removeItem(itemId: preexistingTripItem.id, from: trip.id)
    
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
    let tripItem = TripItem.samples.camera.withoutCategory().withUsageCount(1)
    
    await scenario.sut.createTrip(trip.withoutItems())
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrip = await scenario.firstSavedTrip()
    #expect(initialTrip?.items == [tripItem])
    
    // when
    await scenario.sut.removeItem(itemId: tripItem.id, from: trip.id)
    
    // then
    let updatedTrip = await scenario.firstSavedTrip()
    #expect(updatedTrip?.items == [])
  }
  
  @Test func updateTripItemCheck() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem.samples.camera
    await scenario.sut.createTrip(trip.withoutItems())
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrips = await scenario.sut.trips.waitFirst()
    #expect(initialTrips.orNil()?.first?.items.first?.isChecked == false)
    
    // when
    await scenario.sut.updateItemCheck(tripItemId: tripItem.id, isChecked: true)
    
    // then
    let savedTrip = await scenario.firstSavedTrip()
    #expect(savedTrip?.items.first?.isChecked == true)
  }
  
  @Test func updateTripItemsOrder() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let initialTripItems = [
      TripItem.samples.camera.withOrder(0).withoutCategory().withUsageCount(1),
      TripItem.samples.iPad.withOrder(1).withoutCategory().withUsageCount(1),
      TripItem.samples.nintendoSwitch.withOrder(2).withoutCategory().withUsageCount(1)
    ]
    let reorderedTripItems = [
      TripItem.samples.iPad.withOrder(1),
      TripItem.samples.nintendoSwitch.withOrder(2),
      TripItem.samples.camera.withOrder(0)
    ]
    let expectedTripItems = [
      TripItem.samples.iPad.withOrder(0).withoutCategory().withUsageCount(1),
      TripItem.samples.nintendoSwitch.withOrder(1).withoutCategory().withUsageCount(1),
      TripItem.samples.camera.withOrder(2).withoutCategory().withUsageCount(1)
    ]
    await scenario.sut.createTrip(trip.withoutItems())
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
    // guven
    let scenario = Scenario(
      currentDate: Date.of(year: 2024, month: .jul, day: 15, hour: 6, minute: 35)
    )
    let trips: [Trip: Bool] = [
      Trip.new().withDate(TripDate(year: 2023)): true,
      Trip.new().withDate(TripDate(year: 2024, month: .jun)): true,
      Trip.new().withDate(TripDate(year: 2024, month: .jul, day: 14)): true,
      Trip.new().withDate(TripDate(year: 2024, month: .jul, day: 15)): false,
      Trip.new().withDate(TripDate(year: 2024, month: .jul)): false,
      Trip.new().withDate(TripDate(year: 2024)): false
    ]
    for (trip, _) in trips {
      await scenario.sut.createTrip(trip)
    }
    
    // when
    await scenario.sut.cleanUp()
    
    // then
    let savedTrips = await scenario.sut.trips.waitFirst().orThrow()
    for (trip, shouldBeCompleted) in trips {
      #expect(
        savedTrips.first { $0.id == trip.id }?.isCompleted == shouldBeCompleted,
        "Trip with date \(trip.date) should be \(shouldBeCompleted)"
      )
    }
  }
}

private final class Scenario: @unchecked Sendable {
  
  let sut: RealTripRepository
  
  init(
    currentDate: Date = Date.now
  ) {
    do {
      let container = try ModelContainer(
        for: TripSwiftDataModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      sut = RealTripRepository(
        container: container,
        getCurrentDate: FakeGetCurrentDate(date: currentDate)
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func firstSavedTrip() async -> Trip? {
    await sut.trips.waitFirst().orNil()?.first
  }
}
