import Foundation
import ItemDomain
import QpStorage
import QpUtils
import SwiftData
import SwiftUI
import TripDomain

@Model
public final class ItemSwiftDataModel: IdentifiableModel {
  public var id: String = UUID().uuidString
  public var name: String?
  var tripItems: [TripItemSwiftDataModel]?
  
  public static let typeDescription: String = "item"

  public var modelDescription: String {
    if let name = name {
      "item '\(name)'"
    } else {
      "item"
    }
  }
    
  init(
    id: String,
    name: String
  ) {
    self.id = id
    self.name = name
  }
}

public extension Item {
  func toSwiftDataModel() -> ItemSwiftDataModel {
    ItemSwiftDataModel(
      id: id.value,
      name: name
    )
  }
}

public extension ItemId {
  var fetchDescriptor: FetchDescriptor<ItemSwiftDataModel> {
    FetchDescriptor<ItemSwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

public extension ItemSwiftDataModel {
  func toDomainModel() -> Item {
    Item(
      id: ItemId(id),
      name: name!
    )
  }
}

public extension [ItemSwiftDataModel] {
  func toDomainModels() -> [Item] {
    safeMap { $0.toDomainModel() }
  }
}
