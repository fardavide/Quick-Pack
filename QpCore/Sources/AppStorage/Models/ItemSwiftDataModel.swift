import Foundation
import ItemDomain
import QpStorage
import QpUtils
import SwiftData
import SwiftUI
import TripDomain

@Model
public final class ItemSwiftDataModel: IdentifiableModel {
  public var id: String?
  public var name: String?
  public var tripItems: [TripItemSwiftDataModel]?
  
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
  
  var nameFetchDescriptor: FetchDescriptor<ItemSwiftDataModel> {
    FetchDescriptor<ItemSwiftDataModel>(
      predicate: #Predicate { $0.name == name }
    )
  }
  
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
  func toDomainModel() throws -> Item {
    Item(
      id: ItemId(try id.require("id")),
      name: try name.require("name")
    )
  }
}

public extension [ItemSwiftDataModel] {
  func toDomainModels() -> [Item] {
    sorted { lhs, rhs in (lhs.tripItems?.count ?? 0) > (rhs.tripItems?.count ?? 0) }
    .safeMap { try $0.toDomainModel() }
  }
}
