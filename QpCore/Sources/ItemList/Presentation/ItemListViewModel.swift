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
  
  init(state: ItemListState) {
    self.state = state
  }

  public func send(_ action: ItemListAction) {}
}

public final class RealItemListViewModel: ItemListViewModel {
  
  public let undoHandler: UndoHandler
  private var subscribers: [AnyCancellable] = []
  private let itemRepository: ItemRepository
  
  init(
    itemRepository: ItemRepository,
    initialState: ItemListState = .initial
  ) {
    self.itemRepository = itemRepository
    undoHandler = itemRepository
    super.init(state: initialState)
    
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
  
  private func deleteItem(_ id: ItemId) {
    Task { await itemRepository.deleteItem(itemId: id) }
  }
  
  private func updateItemName(_ id: ItemId, _ newName: String) {
    Task { await itemRepository.updateItemName(itemId: id, name: newName) }
  }
  
  private func findItem(_ id: ItemId) -> Item? {
    switch state.items {
    case let .content(items): items.first(where: { $0.id == id })
    default: nil
    }
  }
}

public final class FakeItemListViewModel: ItemListViewModel {
  public init() {
    super.init(state: .initial)
  }
}
