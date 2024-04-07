import Testing

@testable import DateUtils

final class DateMathTests {
  
  @Test func plusDuration() {
    // given
    let date = Date.of(year: 2023, month: .oct, day: 29)
    
    // when
    let result = date + 3.days()
    
    // then
    #assert(result == Date.of(year: 2023, month: .nov, day: 1))
  }
  
  @Test func minusDuration() {
    // given
    let date = Date.of(year: 2023, month: .oct, day: 29)
    
    // when
    let result = date - 3.days()
    
    // then
    #assert(result == Date.of(year: 2023, month: .oct, day: 26))
  }
  
  @Test func positiveDistance() {
    // given
    let date = Date.of(year: 2023, month: .oct, day: 29)
    let pastDate = Date.of(year: 2023, month: .oct, day: 26)
    
    // when
    let result = date % pastDate
    
    // then
    #assert(result == 3.days())
  }
  
  @Test func negativeDistance() {
    // given
    let date = Date.of(year: 2023, month: .oct, day: 26)
    let futureDate = Date.of(year: 2023, month: .oct, day: 29)
    
    // when
    let result = date % futureDate
    
    // then
    #assert(result == -3.days())
  }
}
