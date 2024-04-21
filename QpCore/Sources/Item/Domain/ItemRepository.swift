import Combine
import QpUtils
import Undo

public protocol ItemRepository: UndoHandler {
  
  var items: any DataPublisher<[Item]> { get }
  var categories: any DataPublisher<[ItemCategory]> { get }
  
  @MainActor func createItem(_ item: Item)
  @MainActor func updateItemCategory(itemId: ItemId, category: ItemCategory?)
  @MainActor func updateItemName(itemId: ItemId, name: String)
  @MainActor func deleteItem(itemId: ItemId)
}

public final class FakeItemRepository: ItemRepository {
  public var items: any DataPublisher<[Item]>
  public var categories: any DataPublisher<[ItemCategory]>
  private var createItemInvocations: [Item] = []
  
  public init(
    items: [Item] = [],
    categories: [ItemCategory] = []
  ) {
    self.items = Just(.success(items))
    self.categories = Just(.success(categories))
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
  public func updateItemCategory(itemId: ItemId, category: ItemCategory?) {}
  public func updateItemName(itemId: ItemId, name: String) {}
  public func deleteItem(itemId: ItemId) {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
