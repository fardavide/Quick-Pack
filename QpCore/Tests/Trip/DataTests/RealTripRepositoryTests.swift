import Testing

import SwiftData
import TripDomain
@testable import TripData

final class RealTripRepositoryTests {
  
  @Test func addTrip() async {
    // given
    let scenario = Scenario()
    
    // when
    await scenario.sut.saveTrip(.samples.malaysia)
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
    
    // when
    await scenario.sut.saveTrip(.samples.malaysia)
    await scenario.sut.saveTrip(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.date == TripDate(year: 2025))
  }
  
  @Test func updateTripItems() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip.samples.malaysia
    let newItems = [
      TripItem(
        item: .samples.camera,
        isChecked: false
      )
    ]
    let updatedTrip = Trip(
      date: initialTrip.date,
      id: initialTrip.id,
      items: newItems,
      name: initialTrip.name
    )
    
    // when
    await scenario.sut.saveTrip(.samples.malaysia)
    await scenario.sut.saveTrip(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.items == newItems)
  }
  
  @Test func updateTripItemCheck() async {
    // given
    let scenario = Scenario()
    let initialTrip = Trip(
      date: Trip.samples.malaysia.date,
      id: Trip.samples.malaysia.id,
      items: [
        TripItem(
          item: .samples.camera,
          isChecked: false
        )
      ],
      name: Trip.samples.malaysia.name
    )
    let newItems = [
      TripItem(
        item: .samples.camera,
        isChecked: true
      )
    ]
    let updatedTrip = Trip(
      date: initialTrip.date,
      id: initialTrip.id,
      items: newItems,
      name: initialTrip.name
    )
    
    // when
    await scenario.sut.saveTrip(.samples.malaysia)
    await scenario.sut.saveTrip(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.items == newItems)
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
    await scenario.sut.saveTrip(.samples.malaysia)
    await scenario.sut.saveTrip(updatedTrip)
    let savedTrips = await scenario.sut.trips.waitFirst()
    
    // then
    #expect(savedTrips.orNil()?.first?.name == "New name")
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
