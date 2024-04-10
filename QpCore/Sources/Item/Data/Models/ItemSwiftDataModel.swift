import Foundation
import QpUtils
import SwiftData
import ItemDomain

@Model
public final class ItemSwiftDataModel: Equatable {
  public var id: String = UUID().uuidString
  var name: String?
  
  init(
    id: String,
    name: String
  ) {
    self.id = id
    self.name = name
  }
}

extension Item {
  func toSwiftDataModel() -> ItemSwiftDataModel {
    ItemSwiftDataModel(
      id: id.value,
      name: name
    )
  }
}

extension ItemId {
  var fetchDescriptor: FetchDescriptor<ItemSwiftDataModel> {
    FetchDescriptor<ItemSwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

extension [ItemSwiftDataModel] {
  func toDomainModels() -> [Item] {
    safeMap { swiftDataModel in
      Item(
        id: ItemId(swiftDataModel.id),
        name: swiftDataModel.name!
      )
    }
  }
}
