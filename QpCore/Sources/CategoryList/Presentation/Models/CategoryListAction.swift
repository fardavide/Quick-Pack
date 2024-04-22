import CategoryDomain
import Foundation

public enum CategoryListAction {
  case delete(_ categoryId: CategoryId)
  case reorderCategories(from: IndexSet, to: Int)
  case updateName(_ categoryId: CategoryId, _ newName: String)
}
