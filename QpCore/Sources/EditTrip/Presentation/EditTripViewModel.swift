import Combine
import Foundation
import ItemDomain
import Presentation
import Provider
import TripDomain

public final class EditTripViewModel: ViewModel {
  public typealias Action = EditTripAction
  public typealias State = EditTripState
  
  @Published public var state: State
  private let itemRepository: ItemRepository
  private let tripRepository: TripRepository

  init(
    initialTrip: Trip,
    itemRepository: ItemRepository,
    tripRepository: TripRepository
  ) {
    self.itemRepository = itemRepository
    self.tripRepository = tripRepository
    state = initialTrip.toEditTripState()
  }
  
  public func send(_ action: EditTripAction) {
    switch action {
    case .addNewItem: addNewItem()
    case let .removeItem(itemId): removeItem(itemId)
    case let .updateDate(newDate): updateDate(newDate)
    case let .updateItemName(itemId, newName): updateItemName(itemId, newName)
    case let .updateName(newName): updateName(newName)
    }
  }
  
  private func addNewItem() {
    let editableItem = EditableTripItem.new()
    state.items.append(editableItem)
    Task { await tripRepository.addItem(editableItem.toTripItem(), to: state.id) }
  }
  
  private func removeItem(_ itemId: ItemId) {
    state.items.removeAll { $0.itemId == itemId }
    if let editableItem = findTripItem(itemId) {
      Task { await tripRepository.addItem(editableItem.toTripItem(), to: state.id) }
    }
  }
  
  private func updateDate(_ newDate: Date) {
    state.date = TripDate(newDate)
    Task { await tripRepository.saveTripMetadata(state.toTrip()) }
  }
  
  func updateItemName(_ itemId: ItemId, _ newName: String) {
    for i in state.items.indices where state.items[i].itemId == itemId {
      state.items[i].name = newName
    }
    if let editableItem = findTripItem(itemId) {
      Task { await itemRepository.saveItem(editableItem.toItem()) }
    }
  }
  
  private func updateName(_ newName: String) {
    state.name = newName
    Task { await tripRepository.saveTripMetadata(state.toTrip()) }
  }
  
  private func findTripItem(_ id: ItemId) -> EditableTripItem? {
    state.items.first(where: { $0.itemId == id })
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
