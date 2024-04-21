import Combine
import QpUtils
import Undo

public protocol CategoryRepository: UndoHandler {
  
  var categories: any DataPublisher<[ItemCategory]> { get }
  
  @MainActor func updateCategoryName(categoryId: CategoryId, name: String)
  @MainActor func deleteCategory(categoryId: CategoryId)
}

public final class FakeCategoryRepository: CategoryRepository {
  public var categories: any DataPublisher<[ItemCategory]>
  
  public init(
    categories: [ItemCategory] = []
  ) {
    self.categories = Just(.success(categories))
  }
  
  public func updateCategoryName(categoryId: CategoryId, name: String) {}
  public func deleteCategory(categoryId: CategoryId) {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
