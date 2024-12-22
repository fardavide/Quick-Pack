import TripDomain

public protocol BuildItemsText {
  func run(_ items: [TripItem]) -> String
}

final class RealBuildItemsText: BuildItemsText {
  func run(_ items: [TripItem]) -> String {
    let total = items.count
    let checked = items.filter(\.isChecked).count
    return switch true {
    case items.isEmpty: "No items"
    case checked == 0: "\(total) items to pack"
    case total == checked: "Ready to go!"
    default: "\(checked) / \(total) items packed"
    }
  }
}
