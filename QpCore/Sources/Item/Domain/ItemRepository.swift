import Combine
import QpUtils

public protocol ItemRepository {
  
  var items: any DataPublisher<[Item]> { get }
  
  func deleteItem(itemId: ItemId) async
  func saveItem(_ item: Item) async
}

public final class FakeItemRepository: ItemRepository {
  public var items: any DataPublisher<[Item]>
  private var saveItemInvocations: [Item] = []
  
  public init(
    items: [Item] = []
  ) {
    self.items = Just(.success(items))
  }
  
  public func lastSavedItem() -> Item? {
    saveItemInvocations.last
  }
  
  public func waitLastSavedItem() async -> Item {
    await waitNonNil { lastSavedItem() }
  }
  
  public func deleteItem(itemId: ItemId) async {}
  public func saveItem(_ item: Item) async {
    saveItemInvocations.append(item)
  }
}
