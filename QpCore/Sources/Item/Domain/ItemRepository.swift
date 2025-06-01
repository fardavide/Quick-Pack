import CategoryDomain
import Combine
import QpUtils
import Undo

public protocol ItemRepository: UndoHandler {
  
  var items: any DataPublisher<[Item]> { get }
  
  @MainActor func createItem(_ item: Item)
  @MainActor func updateItemCategory(itemId: ItemId, category: ItemCategory?)
  @MainActor func updateItemName(itemId: ItemId, name: String)
  @MainActor func deleteItem(itemId: ItemId)
  
  @MainActor func cleanUp()
}

public final class FakeItemRepository: ItemRepository {
  public var items: any DataPublisher<[Item]>
  private var createItemInvocations: [Item] = []
  private var updateItemNameInvocations: [(itemId: ItemId, name: String)] = []
  
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
  
  public func lastUpdateItemName() -> (itemId: ItemId, name: String)? {
    updateItemNameInvocations.last
  }
  
  public func waitLastUpdateItemName() async -> (itemId: ItemId, name: String) {
    await waitNonNil { lastUpdateItemName() }
  }
  
  public func createItem(_ item: Item) {
    createItemInvocations.append(item)
  }
  public func updateItemCategory(itemId: ItemId, category: ItemCategory?) {}
  public func updateItemName(itemId: ItemId, name: String) {
    updateItemNameInvocations.append((itemId: itemId, name: name))
  }
  public func deleteItem(itemId: ItemId) {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
  
  public func cleanUp() {}
}
