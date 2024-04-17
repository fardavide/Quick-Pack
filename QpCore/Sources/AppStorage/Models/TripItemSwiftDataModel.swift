import Foundation
import QpStorage
import SwiftData
import SwiftUI
import TripDomain

@Model
public final class TripItemSwiftDataModel: IdentifiableModel {
  public var id: String = UUID().uuidString
  @Relationship(deleteRule: .nullify, inverse: \ItemSwiftDataModel.tripItems)
  var item: ItemSwiftDataModel?
  public var isChecked: Bool = false
  public var order: Int = 0
  var trip: TripSwiftDataModel?
  
  public static let typeDescription: String = "trip item"

  public var modelDescription: String {
    var result = "trip item"
    if let itemName = item?.name {
      result += " '\(itemName)'"
    }
    if let tripName = trip?.name {
      result += " for trip '\(tripName)'"
    }
    return result
  }
  
  public init(
    id: String,
    item: ItemSwiftDataModel?,
    isChecked: Bool,
    order: Int
  ) {
    self.id = id
    self.item = item
    self.isChecked = isChecked
    self.order = order
  }
}

public extension TripItem {
  func toSwiftDataModel() -> TripItemSwiftDataModel {
    TripItemSwiftDataModel(
      id: item.id.value,
      item: item.toSwiftDataModel(),
      isChecked: isChecked,
      order: order
    )
  }
}

public extension TripItemId {
  var fetchDescriptor: FetchDescriptor<TripItemSwiftDataModel> {
    FetchDescriptor<TripItemSwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

extension [TripItemSwiftDataModel] {
  func toDomainModels() -> [TripItem] {
    safeMap { swiftDataModel in
      TripItem(
        id: TripItemId(swiftDataModel.id),
        item: try swiftDataModel.item.require("Trip item's item").toDomainModel(),
        isChecked: swiftDataModel.isChecked,
        order: swiftDataModel.order
      )
    }
    .sorted()
  }
}
