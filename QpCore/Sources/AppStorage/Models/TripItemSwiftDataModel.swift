import Foundation
import SwiftData
import TripDomain

@Model
public final class TripItemSwiftDataModel: Equatable {
  public var id: String = UUID().uuidString
  @Relationship(deleteRule: .nullify, inverse: \ItemSwiftDataModel.tripItems)
  var item: ItemSwiftDataModel?
  public var isChecked: Bool = false
  var trip: TripSwiftDataModel?
  
  init(
    id: String,
    item: ItemSwiftDataModel?,
    isChecked: Bool = false
  ) {
    self.id = id
    self.item = item
    self.isChecked = isChecked
  }
}

public extension TripItem {
  func toSwiftDataModel() -> TripItemSwiftDataModel {
    TripItemSwiftDataModel(
      id: item.id.value,
      item: item.toSwiftDataModel(),
      isChecked: isChecked
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
        item: swiftDataModel.item!.toDomainModel(),
        isChecked: swiftDataModel.isChecked
      )
    }
  }
}
