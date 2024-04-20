import Combine
import QpUtils
import Undo

public protocol ItemRepository: UndoHandler {
  
  var items: any DataPublisher<[Item]> { get }
  
  @MainActor func createItem(_ item: Item)
  @MainActor func updateItemCategory(itemId: ItemId, category: ItemCategory)
  @MainActor func updateItemName(itemId: ItemId, name: String)
  @MainActor func deleteItem(itemId: ItemId)
}

public final class FakeItemRepository: ItemRepository {
  public var items: any DataPublisher<[Item]>
  private var createItemInvocations: [Item] = []
  
  public init(
    items: [Item] = []
  ) {
    self.items = Just(.success(items))
  }
  
  public func lastCreatedItem() -> Item? {
    createItemInvocations.last
  }
  
  public func waitLastCreatedItem() async -> Item {
    await waitNonNil { lastCreatedItem() }
  }
  
  public func createItem(_ item: Item) {
    createItemInvocations.append(item)
  }
  public func updateItemCategory(itemId: ItemId, category: ItemCategory) {}
  public func updateItemName(itemId: ItemId, name: String) {}
  public func deleteItem(itemId: ItemId) {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
