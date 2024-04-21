import Combine
import Foundation
import ItemDomain
import Presentation
import Provider
import QpUtils
import TripDomain

public final class EditTripViewModel: ViewModel, ObservableObject {
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
    
    tripRepository.trips
      .eraseToAnyPublisher()
      .filterSuccess()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] trips in
        if let viewModel = self, let trip = trips.first(where: { $0.id == initialTrip.id }) {
          viewModel.state = viewModel.state.update(with: trip)
        }
      }
      .store(in: &subscribers)

    itemRepository.items
      .eraseToAnyPublisher()
      .combineLatest(
        $state.map { $0.categories.flatMap(\.items) },
        $state.map { $0.searchQuery.ifEmpty(default: "__query__") }
      )
      .map(filterResult)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] searchResult in
        if let viewModel = self {
          viewModel.state = viewModel.state.withSearchItems(searchResult)
        }
      }
      .store(in: &subscribers)
    
    itemRepository.categories
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] allCategories in
        if let viewModel = self {
          viewModel.state = viewModel.state.withAllCategories(allCategories.toLce())
        }
      }
      .store(in: &subscribers)
  }
  
  public func send(_ action: EditTripAction) {
    switch action {
    case let .addItem(item): addItem(item)
    case let .addNewItem(name): addNewItem(name)
    case let .deleteItem(itemId): deleteItem(itemId)
    case let .removeItem(itemId): removeItem(itemId)
    case let .reorderItems(categoryId, from, to): reorderItems(categoryId, from, to)
    case let .searchItem(query): searchItem(query)
    case let .updateDate(newDate): updateDate(newDate)
    case let .updateItemCategory(tripItem, newCategory): updateItemCategory(tripItem, newCategory)
    case let .updateItemCheck(itemId, newIsChecked): updateItemCheck(itemId, newIsChecked)
    case let .updateItemName(itemId, newName): updateItemName(itemId, newName)
    case let .updateName(newName): updateName(newName)
    }
  }

  private func addItem(_ item: Item) {
    let tripItem = TripItem(id: .new(), item: item, isChecked: false, order: 0)
    state = state.insertItem(tripItem)
    Task { await tripRepository.addItem(tripItem, to: state.id) }
  }
  
  private func addNewItem(_ name: String) {
    let tripItem = TripItem.new(item: .new(name: name))
    state = state.insertItem(tripItem)
    Task { await tripRepository.addItem(tripItem, to: state.id) }
  }
  
  private func deleteItem(_ id: ItemId) {
    state = state.removeItem(itemId: id)
    Task { await itemRepository.deleteItem(itemId: id) }
  }
  
  private func reorderItems(
    _ categoryId: CategoryId?,
    _ from: IndexSet,
    _ to: Int
  ) {
    state = state.moveItems(for: categoryId, from: from, to: to)
    if let items = state.categories.first(where: { $0.category?.id == categoryId })?.items {
      Task { await tripRepository.updateItemsOrder(sortedItems: items) }
    }
  }
  
  private func removeItem(_ itemId: TripItemId) {
    state = state.removeItem(tripItemId: itemId)
    Task { await tripRepository.removeItem(itemId: itemId, from: state.id) }
  }
  
  private func searchItem(_ query: String) {
    state = state.withSearchQuery(query)
  }
  
  private func updateDate(_ newDate: TripDate?) {
    state = state.withDate(newDate)
    Task { await tripRepository.updateTripDate(tripId: state.id, date: state.date) }
  }
  
  func updateItemCategory(_ tripItem: TripItem, _ newCategory: ItemCategory?) {
    state = state.updateItemCategory(tripItem: tripItem, newCategory)
    Task { await itemRepository.updateItemCategory(itemId: tripItem.item.id, category: newCategory) }
  }
  
  private func updateItemCheck(_ itemId: TripItemId, _ newIsChecked: Bool) {
    state = state.updateItemCheck(tripItemId: itemId, newIsChecked)
    Task { await tripRepository.updateItemCheck(tripItemId: itemId, isChecked: newIsChecked) }
  }
  
  private func updateItemName(_ itemId: ItemId, _ newName: String) {
    state = state.updateItemName(itemId: itemId, newName)
    Task { await itemRepository.updateItemName(itemId: itemId, name: newName) }
  }
  
  private func updateName(_ newName: String) {
    state = state.withName(newName)
    Task { await tripRepository.updateTripName(tripId: state.id, name: state.name) }
  }
  
  private func filterResult(
    result: Result<[Item], DataError>,
    tripItems: [TripItem],
    searchQuery: String
  ) -> [Item] {
    let nonUsedItems = result.or(default: [])
      .filter { item in !tripItems.contains { tripItem in tripItem.item.id == item.id } }
    let result = nonUsedItems.partitioned { item in
      !item.name.localizedCaseInsensitiveContains(searchQuery)
    }[..<min(3, nonUsedItems.endIndex)]
    return Array(result)
  }
  
  public protocol Factory: ProviderFactory<Trip, EditTripViewModel> {}
  public final class RealFactory: Factory {
    private let itemRepository: ItemRepository
    private let tripRepository: TripRepository
    private var cache: [TripId: EditTripViewModel] = [:]
    public init(
      itemRepository: ItemRepository,
      tripRepository: TripRepository
    ) {
      self.itemRepository = itemRepository
      self.tripRepository = tripRepository
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      cache.getOrSet(
        input.id,
        EditTripViewModel(
          initialTrip: input,
          itemRepository: itemRepository,
          tripRepository: tripRepository
        )
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
