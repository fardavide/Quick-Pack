import Combine
import Foundation
import ItemDomain
import Presentation
import Provider
import QpUtils
import TripDomain

public final class EditTripViewModel: ViewModel {
  public typealias Action = EditTripAction
  public typealias State = EditTripState
  
  @Published public var state: State
  private var subscribers: [AnyCancellable] = []
  private let itemRepository: ItemRepository
  private let tripRepository: TripRepository

  init(
    initialTrip: Trip,
    itemRepository: ItemRepository,
    tripRepository: TripRepository
  ) {
    self.itemRepository = itemRepository
    self.tripRepository = tripRepository
    state = initialTrip.toInitialEditTripState()
    
    itemRepository.items
      .eraseToAnyPublisher()
      .combineLatest($state.map(\EditTripState.searchQuery).filter(\.isNotEmpty))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (result, searchQuery) in
        guard self != nil else {
          return
        }
        let newSearchItems = result.or(default: [])
          .filter { item in
            item.name.localizedCaseInsensitiveContains(searchQuery)
          }
        self!.state = self!.state.withSearchItems(newSearchItems)
      }
      .store(in: &subscribers)
  }
  
  public func send(_ action: EditTripAction) {
    switch action {
    case .addNewItem: addNewItem()
    case let .deleteItem(itemId): deleteItem(itemId)
    case let .removeItem(itemId): removeItem(itemId)
    case let .reorderItems(from, to): reorderItems(from, to)
    case let .searchItem(query): searchItem(query)
    case let .updateDate(newDate): updateDate(newDate)
    case let .updateItemCheck(itemId, newIsChecked): updateItemCheck(itemId, newIsChecked)
    case let .updateItemName(itemId, newName): updateItemName(itemId, newName)
    case let .updateName(newName): updateName(newName)
    }
  }
  
  private func addNewItem() {
    let editableItem = EditableTripItem.new()
    state = state.insertItem(editableItem)
    Task { await tripRepository.addItem(editableItem.toTripItem(), to: state.id) }
  }
  
  private func deleteItem(_ id: ItemId) {
    state = state.removeItem(id: id)
    Task { await itemRepository.deleteItem(itemId: id) }
  }
  
  private func reorderItems(
    _ from: IndexSet,
    _ to: Int
  ) {
    state = state.moveItems(from: from, to: to)
    Task { await tripRepository.updateItemsOrder(sortedItems: state.toTrip().items) }
  }
  
  private func removeItem(_ itemId: TripItemId) {
    state = state.removeItem(id: itemId)
    Task { await tripRepository.removeItem(itemId, from: state.id) }
  }
  
  private func searchItem(_ query: String) {
    state = state.withSearchQuery(query)
  }
  
  private func updateDate(_ newDate: Date) {
    state = state.withDate(newDate)
    Task { await tripRepository.saveTripMetadata(state.toTrip()) }
  }
  
  func updateItemCheck(_ itemId: TripItemId, _ newIsChecked: Bool) {
    state = state.updateItemCheck(id: itemId, newIsChecked)
    if let editableItem = findTripItem(itemId) {
      Task { await tripRepository.updateItemCheck(editableItem.id, isChecked: newIsChecked) }
    }
  }
  
  func updateItemName(_ itemId: ItemId, _ newName: String) {
    state = state.updateItemName(id: itemId, newName)
    if let editableItem = findItem(itemId) {
      Task { await itemRepository.saveItem(editableItem.toItem()) }
    }
  }
  
  private func updateName(_ newName: String) {
    state = state.withName(newName)
    Task { await tripRepository.saveTripMetadata(state.toTrip()) }
  }
  
  private func findItem(_ id: ItemId) -> EditableTripItem? {
    state.tripItems.first(where: { $0.itemId == id })
  }
  
  private func findTripItem(_ id: TripItemId) -> EditableTripItem? {
    state.tripItems.first(where: { $0.id == id })
  }
  
  public protocol Factory: ProviderFactory<Trip, EditTripViewModel> {}
  public final class RealFactory: Factory {
    private let itemRepository: ItemRepository
    private let tripRepository: TripRepository
    public init(
      itemRepository: ItemRepository,
      tripRepository: TripRepository
    ) {
      self.itemRepository = itemRepository
      self.tripRepository = tripRepository
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      EditTripViewModel(
        initialTrip: input,
        itemRepository: itemRepository,
        tripRepository: tripRepository
      )
    }
  }
  public final class FakeFactory: Factory {
    private let viewModel: EditTripViewModel
    public init(viewModel: EditTripViewModel) {
      self.viewModel = viewModel
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      viewModel
    }
  }
}

public extension EditTripViewModel {
  static let samples = EditTripViewModelSamples()
}

public final class EditTripViewModelSamples {
  public let content = EditTripViewModel(
    initialTrip: .samples.malaysia,
    itemRepository: FakeItemRepository(),
    tripRepository: FakeTripRepository()
  )
}
