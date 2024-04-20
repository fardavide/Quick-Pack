import Testing

@testable import QpUtils

final class ArrayUtilsTests {
  
  @Test func group() {
    // given
    struct Item: Equatable {
      let category: String
      let name: String
    }
    let input = [
      Item(category: "clothes", name: "shoes"),
      Item(category: "tech", name: "iPad"),
      Item(category: "clothes", name: "t-shirt"),
      Item(category: "misc", name: "tobacco"),
      Item(category: "tech", name: "phone"),
      Item(category: "clothes", name: "pants")
    ]
    
    // when
    let result = input.group(by: \.category)
    
    // then
    #expect(result.keys.sorted() == ["clothes", "misc", "tech"])
    #expect(
      result["clothes"] == [
        Item(category: "clothes", name: "shoes"),
        Item(category: "clothes", name: "t-shirt"),
        Item(category: "clothes", name: "pants")
      ]
    )
    #expect(
      result["misc"] == [
        Item(category: "misc", name: "tobacco")
      ]
    )
    #expect(
      result["tech"] == [
        Item(category: "tech", name: "iPad"),
        Item(category: "tech", name: "phone")
      ]
    )
  }
}
