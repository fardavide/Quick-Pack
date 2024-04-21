import CategoryDomain

public enum CategoryListAction {
  case delete(_ categoryId: CategoryId)
  case updateName(_ categoryId: CategoryId, _ newName: String)
}
