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
    case let .updateName(id, newName): updateItemName(id, newName)
    }
  }
  
  private func deleteItem(_ id: CategoryId) {
    Task { await categoryRepository.deleteCategory(categoryId: id) }
  }
  
  private func updateItemName(_ id: CategoryId, _ newName: String) {
    Task { await categoryRepository.updateCategoryName(categoryId: id, name: newName) }
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
