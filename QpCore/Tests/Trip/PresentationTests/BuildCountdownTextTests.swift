import DateUtils
import Foundation
import Testing
import TripDomain

@testable import TripPresentation

class BuildCountdownTextTests {
  
  @Test func givenExactPrecision_whenSameDay_textIsToday() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.xmas2024) == "Today")
  }
  
  @Test func givenExactPrecision_whenOneDayBefore_textIsTomorrow() {
    let scenario = Scenario(currentDate: .samples.dec24th2024)
    #expect(scenario.sut.run(to: .samples.xmas2024) == "Tomorrow")
  }
  
  @Test func givenExactPrecision_whenTwoDaysBefore_textIsInTwoDays() {
    let scenario = Scenario(currentDate: .samples.dec23rd2024)
    #expect(scenario.sut.run(to: .samples.xmas2024) == "In 2 days")
  }
  
  @Test func givenExactPrecision_whenOneDayAfter_textIsYesterday() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.dec24th2024) == "Yesterday")
  }
  
  @Test func givenExactPrecision_whenTwoDaysAfter_textIsTwoDaysAgo() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.dec23rd2024) == "2 days ago")
  }
  
  @Test func givenMonthPrecision_whenSameMonth_textIsThisMonth() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.dec2024) == "This month")
  }
  
  @Test func givenMonthPrecision_whenOneMonthBefore_textIsNextMonth() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.jan2025) == "Next month")
  }
  
  @Test func givenMonthPrecision_whenTwoMonthsBefore_textIsInTwoMonths() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.feb2025) == "In 2 months")
  }
  
  @Test func givenMonthPrecision_whenOneMonthAfter_textIsLastMonth() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.nov2024) == "Last month")
  }
  
  @Test func givenMonthPrecision_whenTwoMonthsAfter_textIsTwoMonthsAgo() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.oct2024) == "2 months ago")
  }
  
  @Test func givenYearPrecision_whenSameYear_textIsThisYear() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.year2024) == "This year")
  }
  
  @Test func givenYearPrecision_whenOneYearBefore_textIsNextYear() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.year2025) == "Next year")
  }
  
  @Test func givenYearPrecision_whenTwoYearsBefore_textIsInTwoYears() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.year2026) == "In 2 years")
  }
  
  @Test func givenYearPrecision_whenOneYearAfter_textIsLastYear() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.year2023) == "Last year")
  }
  
  @Test func givenYearPrecision_whenTwoYearsAfter_textIsTwoYearsAgo() {
    let scenario = Scenario(currentDate: .samples.xmas2024)
    #expect(scenario.sut.run(to: .samples.year2022) == "2 years ago")
  }
  
  struct Scenario {
    let sut: BuildCountdownText
    
    init(currentDate: Date) {
      sut = RealBuildCountdownText(getCurrentDate: FakeGetCurrentDate(date: currentDate))
    }
  }
}
