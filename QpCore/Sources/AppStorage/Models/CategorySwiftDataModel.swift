import ItemDomain
import QpStorage
import SwiftData

@Model
public class CategorySwiftDataModel: IdentifiableModel {
  public var id: String?
  public var name: String?
  public var items: [ItemSwiftDataModel]?
  
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
    name: String
  ) {
    self.id = id
    self.name = name
  }
}

public extension Category {
  
  func toSwiftDataModel() -> CategorySwiftDataModel {
    CategorySwiftDataModel(
      id: id.value,
      name: name
    )
  }
}

public extension CategorySwiftDataModel {
  func toDomainModel() throws -> Category {
    Category(
      id: CategoryId(try id.require("id")),
      name: try name.require("name")
    )
  }
}
