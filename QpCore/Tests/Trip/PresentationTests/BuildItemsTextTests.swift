import Testing
import TripDomain

@testable import TripPresentation

class BuildItemsTextTests {
  
  @Test func whenNoItems_textIsNoItems() {
    let scenario = Scenario()
    let items: [TripItem] = []
    #expect(scenario.sut.run(items) == "No items")
  }
  
  @Test func givenItems_whenNoneChecked_textIsNItemsToPack() {
    let scenario = Scenario()
    let items: [TripItem] = [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ]
    #expect(scenario.sut.run(items) == "3 items to pack")
  }
  
  @Test func givenItems_whenSomeChecked_textIsNSlashNItemsPacked() {
    let scenario = Scenario()
    let items: [TripItem] = [
      .samples.camera,
      .samples.iPad.withCheck(),
      .samples.nintendoSwitch
    ]
    #expect(scenario.sut.run(items) == "1 / 3 items packed")
  }
  
  @Test func givenItems_whenAllChecked_textIsReadyToGo() {
    let scenario = Scenario()
    let items: [TripItem] = [
      .samples.camera.withCheck(),
      .samples.iPad.withCheck(),
      .samples.nintendoSwitch.withCheck()
    ]
    #expect(scenario.sut.run(items) == "Ready to go!")
  }
  
  struct Scenario {
    let sut: BuildItemsText
    
    init() {
      sut = RealBuildItemsText()
    }
  }
}
