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
    await scenario.sut.saveTripMetadata(.samples.malaysia)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first == .samples.malaysia)
  }
  
  @Test func updateTripDate() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip.samples.malaysia
    let updatedTrip = Trip(
      date: TripDate(year: 2025),
      id: initialTrip.id,
      items: initialTrip.items,
      name: initialTrip.name
    )
    await scenario.sut.saveTripMetadata(.samples.malaysia)

    // when
    await scenario.sut.saveTripMetadata(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.date == TripDate(year: 2025))
  }
  
  @Test func updateTripName() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip.samples.malaysia
    let updatedTrip = Trip(
      date: initialTrip.date,
      id: initialTrip.id,
      items: initialTrip.items,
      name: "New name"
    )
    
    // when
    await scenario.sut.saveTripMetadata(.samples.malaysia)
    await scenario.sut.saveTripMetadata(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.name == "New name")
  }
  
  @Test func addTripItem() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem(
      id: .samples.camera,
      item: .samples.camera,
      isChecked: false
    )
    await scenario.sut.saveTripMetadata(.samples.malaysia)

    // when
    await scenario.sut.addItem(tripItem, to: trip.id)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.items == [tripItem])
  }
  
  @Test func removeTripItem() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem(
      id: .samples.camera,
      item: .samples.camera,
      isChecked: false
    )
    
    await scenario.sut.saveTripMetadata(.samples.malaysia)
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrips = await scenario.sut.trips.waitFirst()
    #expect(initialTrips.orNil()?.first?.items == [tripItem])
    
    // when
    await scenario.sut.removeItem(tripItem.id, from: trip.id)
    let updatedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(updatedTrips.orNil()?.first?.items == [])
  }
  
  @Test func updateTripItemCheck() async {
    // given
    let scenario = Scenario()
    let trip = Trip.samples.malaysia
    let tripItem = TripItem(
      id: .samples.camera,
      item: .samples.camera,
      isChecked: false
    )
    await scenario.sut.saveTripMetadata(.samples.malaysia)
    await scenario.sut.addItem(tripItem, to: trip.id)
    let initialTrips = await scenario.sut.trips.waitFirst()
    #expect(initialTrips.orNil()?.first?.items.first?.isChecked == false)

    // when
    await scenario.sut.updateItemCheck(tripItem.id, isChecked: true)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.items.first?.isChecked == true)
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
}
