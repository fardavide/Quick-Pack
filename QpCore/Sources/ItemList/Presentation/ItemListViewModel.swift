import Combine
import Foundation
import ItemDomain
import Presentation
import QpUtils
import Undo

public class ItemListViewModel: ViewModel, ObservableObject {
  public typealias Action = ItemListAction
  public typealias State = ItemListState
  
  @Published public var state: ItemListState
  public let undoHandler: UndoHandler

  init(
    state: ItemListState,
    undoHandler: UndoHandler
  ) {
    self.state = state
    self.undoHandler = undoHandler
  }

  public func send(_ action: ItemListAction) {}
}

public final class RealItemListViewModel: ItemListViewModel {
  
  private var subscribers: [AnyCancellable] = []
  private let itemRepository: ItemRepository
  
  init(
    itemRepository: ItemRepository,
    initialState: ItemListState = .initial
  ) {
    self.itemRepository = itemRepository
    super.init(
      state: initialState,
      undoHandler: itemRepository
    )
    
    itemRepository.items
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.state = ItemListState(
          items: result.toLce()
        )
      }
      .store(in: &subscribers)
  }
  
  public override func send(_ action: ItemListAction) {
    switch action {
    case let .delete(id): deleteItem(id)
    case let .updateName(id, newName): updateItemName(id, newName)
    }
  }
  
  @MainActor private func deleteItem(_ id: ItemId) {
    Task { itemRepository.deleteItem(itemId: id) }
  }
  
  @MainActor private func updateItemName(_ id: ItemId, _ newName: String) {
    Task { itemRepository.updateItemName(itemId: id, name: newName) }
  }
}

public final class FakeItemListViewModel: ItemListViewModel {
  public init() {
    super.init(
      state: .initial,
      undoHandler: FakeUndoHandler()
    )
  }
}
