import Foundation
import SwiftData
import TripDomain

@Model
public final class TripItemSwiftDataModel: Equatable {
  public var id: String = UUID().uuidString
  @Relationship(deleteRule: .nullify, inverse: \ItemSwiftDataModel.tripItems)
  var item: ItemSwiftDataModel?
  public var isChecked: Bool = false
  public var order: Int = 0
  var trip: TripSwiftDataModel?
  
  init(
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
        item: try swiftDataModel.item.require().toDomainModel(),
        isChecked: swiftDataModel.isChecked,
        order: swiftDataModel.order
      )
    }
    .sorted()
  }
}
