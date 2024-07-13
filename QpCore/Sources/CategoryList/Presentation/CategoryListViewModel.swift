import CategoryDomain
import Combine
import Foundation
import Presentation
import QpUtils
import Undo

public class CategoryListViewModel: ViewModel, ObservableObject {
  public typealias Action = CategoryListAction
  public typealias State = CategoryListState
  
  @Published public var state: CategoryListState
  public let undoHandler: UndoHandler
  
  init(
    state: CategoryListState,
    undoHandler: UndoHandler
  ) {
    self.state = state
    self.undoHandler = undoHandler
  }
  
  public func send(_ action: CategoryListAction) {}
}

public final class RealCategoryListViewModel: CategoryListViewModel {
  
  private var subscribers: [AnyCancellable] = []
  private let categoryRepository: CategoryRepository
  
  init(
    categoryRepository: CategoryRepository,
    initialState: CategoryListState = .initial
  ) {
    self.categoryRepository = categoryRepository
    super.init(
      state: initialState,
      undoHandler: categoryRepository
    )
    
    categoryRepository.categories
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.state = CategoryListState(
          categories: result.toLce()
        )
      }
      .store(in: &subscribers)
  }
  
  public override func send(_ action: CategoryListAction) {
    switch action {
    case let .delete(id): deleteItem(id)
    case let .reorderCategories(from, to): reorderCategories(from, to)
    case let .updateName(id, newName): updateItemName(id, newName)
    }
  }
  
  @MainActor private func deleteItem(_ id: CategoryId) {
    state = state.removeCategory(categoryId: id)
    Task { categoryRepository.deleteCategory(categoryId: id) }
  }
  
  @MainActor private func reorderCategories(_ from: IndexSet, _ to: Int) {
    state = state.moveCategories(from: from, to: to)
    if let sortedCategories = state.categories.content {
      Task { categoryRepository.updateCategoriesOrder(sortedCategories: sortedCategories) }
    }
  }
  
  @MainActor private func updateItemName(_ id: CategoryId, _ newName: String) {
    state = state.updateCategoryName(categoryId: id, newName: newName)
    Task { categoryRepository.updateCategoryName(categoryId: id, name: newName) }
  }
}

public final class FakeCategoryListViewModel: CategoryListViewModel {
  public init() {
    super.init(
      state: .initial,
      undoHandler: FakeUndoHandler()
    )
  }
}
