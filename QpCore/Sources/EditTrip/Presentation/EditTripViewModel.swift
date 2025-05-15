import CategoryDomain
import Combine
import Foundation
import ItemDomain
import Notifications
import Presentation
import Provider
import QpUtils
import TripDomain
import UserNotifications

public final class EditTripViewModel: ViewModel, ObservableObject {
  public typealias Action = EditTripAction
  public typealias State = EditTripState
  
  @Published public var state: State
  private var subscribers: [AnyCancellable] = []
  private let categoryRepository: CategoryRepository
  private let itemRepository: ItemRepository
  private let scheduleRemindersTask: ScheduleReminders
  private let tripRepository: TripRepository

  init(
    initialTrip: Trip,
    categoryRepository: CategoryRepository,
    itemRepository: ItemRepository,
    scheduleRemindersTask: ScheduleReminders,
    tripRepository: TripRepository
  ) {
    self.categoryRepository = categoryRepository
    self.itemRepository = itemRepository
    self.scheduleRemindersTask = scheduleRemindersTask
    self.tripRepository = tripRepository
    state = initialTrip.toInitialEditTripState()
    
    tripRepository.trips
      .eraseToAnyPublisher()
      .filterSuccess()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] trips in
        if let self, let trip = trips.first(where: { $0.id == initialTrip.id }) {
          state = state.update(with: trip)
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
        if let self {
          state = state.withSearchItems(searchResult)
        }
      }
      .store(in: &subscribers)
    
    categoryRepository.categories
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] allCategories in
        if let self {
          state = state.withAllCategories(allCategories.toLce())
        }
      }
      .store(in: &subscribers)
  }
  
  // swiftlint:disable cyclomatic_complexity
  public func send(_ action: EditTripAction) {
    switch action {
    case let .addItem(item): addItem(item)
    case let .addNewItem(name): addNewItem(name)
    case let .deleteItem(itemId): deleteItem(itemId)
    case let .handleRequest(request): handleRequest(request)
    case let .removeItem(itemId): removeItem(itemId)
    case let .reorderItems(categoryId, from, to): reorderItems(categoryId, from, to)
    case .requestNotificationsAuthorization: requestNotificationsAuthorization()
    case let .searchItem(query): searchItem(query)
    case let .updateDate(newDate): updateDate(newDate)
    case let .updateItemCategory(tripItem, newCategory): updateItemCategory(tripItem, newCategory)
    case let .updateItemCheck(tripItemId, newIsChecked): updateItemCheck(tripItemId, newIsChecked)
    case let .updateItemNotes(tripItemId, newNotes): updateItemNotes(tripItemId, newNotes)
    case let .updateItemName(itemId, newName): updateItemName(itemId, newName)
    case let .updateName(newName): updateName(newName)
    case let .updateReminder(newReminder): updateReminder(newReminder)
    }
  }
  // swiftlint:enable cyclomatic_complexity

  @MainActor private func addItem(_ item: Item) {
    let tripItem = TripItem.new(item: item)
    state = state.insertItem(tripItem).withSearchQuery("")
    Task { tripRepository.addItem(tripItem, to: state.id) }
  }
  
  @MainActor private func addNewItem(_ name: String) {
    let tripItem = TripItem.new(item: .new(name: name))
    state = state
      .insertItem(tripItem)
      .withSearchQuery("")
      .withRequest(.showSetCategory(item: tripItem))
    Task { tripRepository.addItem(tripItem, to: state.id) }
  }
  
  @MainActor private func deleteItem(_ id: ItemId) {
    state = state.removeItem(itemId: id)
    Task { itemRepository.deleteItem(itemId: id) }
  }
  
  @MainActor private func handleRequest(_ request: EditTripRequest?) {
    state = state.withRequest(request)
  }
  
  @MainActor private func reorderItems(
    _ categoryId: CategoryId?,
    _ from: IndexSet,
    _ to: Int
  ) {
    state = state.moveItems(for: categoryId, from: from, to: to)
    if let items = state.categories.first(where: { $0.category?.id == categoryId })?.items {
      Task { tripRepository.updateItemsOrder(sortedItems: items) }
    }
  }
  
  @MainActor private func requestNotificationsAuthorization() {
    Task {
      do {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
      } catch {
        print(error)
      }
    }
  }
  
  @MainActor private func removeItem(_ tripItemId: TripItemId) {
    state = state.removeItem(tripItemId: tripItemId)
    Task { tripRepository.removeItem(itemId: tripItemId, from: state.id) }
  }
  
  @MainActor private func searchItem(_ query: String) {
    state = state.withSearchQuery(query)
  }
  
  @MainActor private func updateDate(_ newDate: TripDate?) {
    state = state.withDate(newDate)
    Task { tripRepository.updateTripDate(tripId: state.id, date: newDate) }
  }
  
  @MainActor func updateItemCategory(_ tripItem: TripItem, _ newCategory: ItemCategory?) {
    state = state.updateItemCategory(tripItem: tripItem, newCategory)
    Task { itemRepository.updateItemCategory(itemId: tripItem.item.id, category: newCategory) }
  }
  
  @MainActor private func updateItemCheck(_ itemId: TripItemId, _ newIsChecked: Bool) {
    state = state.updateItemCheck(tripItemId: itemId, newIsChecked)
    Task { tripRepository.updateItemCheck(tripItemId: itemId, isChecked: newIsChecked) }
  }
  
  @MainActor private func updateItemName(_ itemId: ItemId, _ newName: String) {
    state = state.updateItemName(itemId: itemId, newName)
    Task { itemRepository.updateItemName(itemId: itemId, name: newName) }
  }
  
  @MainActor private func updateItemNotes(_ itemId: TripItemId, _ newNotes: String) {
    state = state.updateItemNotes(tripItemId: itemId, newNotes)
    Task { tripRepository.updateItemNotes(tripItemId: itemId, notes: newNotes) }
  }
  
  @MainActor private func updateName(_ newName: String) {
    state = state.withName(newName)
    Task { tripRepository.updateTripName(tripId: state.id, name: newName) }
  }
  
  @MainActor private func updateReminder(_ newReminder: Date?) {
    state = state.withReminder(newReminder)
    Task {
      tripRepository.updateReminder(tripId: state.id, reminder: newReminder)
      scheduleRemindersTask.run()
    }
  }
  
  private func filterResult(
    allItemsResult: Result<[Item], DataError>,
    tripItems: [TripItem],
    searchQuery: String
  ) -> SearchItemResultModel {
    let nonUsedItems = allItemsResult.or(default: [])
      .filter { item in !tripItems.contains { tripItem in tripItem.item.id == item.id } }
    let result = nonUsedItems.partitioned { item in
      !item.name.localizedCaseInsensitiveContains(searchQuery)
    }
    let filteredItems = result[..<min(5, nonUsedItems.endIndex)]
    return SearchItemResultModel(
      all: nonUsedItems,
      filtered: Array(filteredItems)
    )
  }
  
  public protocol Factory: ProviderFactory<Trip, EditTripViewModel> {}
  public final class RealFactory: Factory {
    private let categoryRepository: CategoryRepository
    private let itemRepository: ItemRepository
    private let scheduleRemindersTask: ScheduleReminders
    private let tripRepository: TripRepository
    private var cache: [TripId: EditTripViewModel] = [:]
    
    public init(
      categoryRepository: CategoryRepository,
      itemRepository: ItemRepository,
      scheduleRemindersTask: ScheduleReminders,
      tripRepository: TripRepository
    ) {
      self.categoryRepository = categoryRepository
      self.itemRepository = itemRepository
      self.scheduleRemindersTask = scheduleRemindersTask
      self.tripRepository = tripRepository
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      cache.getOrSet(
        input.id,
        EditTripViewModel(
          initialTrip: input,
          categoryRepository: categoryRepository,
          itemRepository: itemRepository,
          scheduleRemindersTask: scheduleRemindersTask,
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

public final class EditTripViewModelSamples: Sendable {
  public func content() -> EditTripViewModel {
    EditTripViewModel(
      initialTrip: .samples.malaysia,
      categoryRepository: FakeCategoryRepository(),
      itemRepository: FakeItemRepository(),
      scheduleRemindersTask: FakeScheduleReminders(),
      tripRepository: FakeTripRepository()
    )
  }
}
