import CategoryDomain
import ItemDomain
import QpStorage
import SwiftData
import SwiftUI

@Model
public class CategorySwiftDataModel: IdentifiableModel {
  public var id: String?
  public var name: String?
  public var items: [ItemSwiftDataModel]?
  public var order: Int = 0
  
  public static let typeDescription: String = "category"
  
  public var modelDescription: String {
    if let name = name {
      "category '\(name)'"
    } else {
      "category"
    }
  }
  
  init(
    id: String,
    name: String,
    order: Int
  ) {
    self.id = id
    self.name = name
    self.order = order
  }
}

public extension ItemCategory {
  
  var nameFetchDescriptor: FetchDescriptor<CategorySwiftDataModel> {
    FetchDescriptor<CategorySwiftDataModel>(
      predicate: #Predicate { $0.name == name }
    )
  }
  
  func toSwiftDataModel() -> CategorySwiftDataModel {
    CategorySwiftDataModel(
      id: id.value,
      name: name,
      order: order
    )
  }
}

public extension CategoryId {
  var fetchDescriptor: FetchDescriptor<CategorySwiftDataModel> {
    FetchDescriptor<CategorySwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

public extension CategorySwiftDataModel {
  func toDomainModel() throws -> ItemCategory {
    ItemCategory(
      id: CategoryId(try id.require("id")),
      name: try name.require("name"),
      order: order
    )
  }
}

public extension [CategorySwiftDataModel] {
  func toDomainModels() -> [ItemCategory] {
    safeMap { try $0.toDomainModel() }
  }
}
