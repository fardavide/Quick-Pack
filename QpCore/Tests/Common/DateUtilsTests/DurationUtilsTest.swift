@testable import DateUtils
import Foundation
import Testing

struct DurationUtilsTest {
  
  @Test func seconds() {
    #expect(3.seconds() == Duration(secondsComponent: 3, attosecondsComponent: 0))
  }
  
  @Test func minutes() {
    #expect(3.minutes() == Duration(secondsComponent: 180, attosecondsComponent: 0))
  }
  
  @Test func hours() {
    #expect(3.hours() == Duration(secondsComponent: 10_800, attosecondsComponent: 0))
  }
  
  @Test func days() {
    #expect(3.days() == Duration(secondsComponent: 259_200, attosecondsComponent: 0))
  }
}
