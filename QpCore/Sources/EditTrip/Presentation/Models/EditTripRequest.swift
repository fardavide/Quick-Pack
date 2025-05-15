import ItemDomain
import SwiftUI
import TripDomain

public enum EditTripRequest: Equatable, Sendable {
  case showAllItems(_ items: [Item])
  case showRename(_ tripItem: TripItem)
  case showSetCategory(_ tripItem: TripItem)
  case showSetNotes(_ tripItem: TripItem)
}

extension EditTripRequest? {
  
  var tripItem: TripItem? {
    switch self {
    case .showAllItems: return nil
    case let .showRename(tripItem): return tripItem
    case let .showSetCategory(tripItem): return tripItem
    case let .showSetNotes(tripItem): return tripItem
    case .none: return nil
    }
  }
  
  func bindAllItems(hide: @escaping () -> Void) -> Binding<EditTripRequestBindingValue> {
    .init(
      get: {
        if case let .showAllItems(items) = self {
          .allItemsPresented(items, hide: hide)
        } else {
          .hidden
        }
      },
      set: { value in
        if case .hidden = value {
          hide()
        }
      }
    )
  }
  
  func bindRename(hide: @escaping () -> Void) -> Binding<EditTripRequestBindingValue> {
    .init(
      get: {
        if case let .showRename(tripItem) = self {
          .presented(tripItem, hide: hide)
        } else {
          .hidden
        }
      },
      set: { value in
        if case .hidden = value {
          hide()
        }
      }
    )
  }
  
  func bindSetCategory(hide: @escaping () -> Void) -> Binding<EditTripRequestBindingValue> {
    .init(
      get: {
        if case let .showSetCategory(tripItem) = self {
          .presented(tripItem, hide: hide)
        } else {
          .hidden
        }
      },
      set: { value in
        if case .hidden = value {
          hide()
        }
      }
    )
  }
  
  func bindSetNotes(hide: @escaping () -> Void) -> Binding<EditTripRequestBindingValue> {
    .init(
      get: {
        if case let .showSetNotes(tripItem) = self {
          .presented(tripItem, hide: hide)
        } else {
          .hidden
        }
      },
      set: { value in
        if case .hidden = value {
          hide()
        }
      }
    )
  }
}

enum EditTripRequestBindingValue {
  case allItemsPresented(_ items: [Item], hide: () -> Void)
  case presented(_ tripItem: TripItem, hide: () -> Void)
  case hidden
}

extension Binding<EditTripRequestBindingValue> {
  
  var isPresented: Binding<Bool> {
    .init(
      get: {
        switch wrappedValue {
        case .allItemsPresented: true
        case .presented: true
        case .hidden: false
        }
      },
      set: { isPresented in
        if case let .allItemsPresented(_, hide) = wrappedValue, !isPresented {
          hide()
        }
        if case let .presented(_, hide) = wrappedValue, !isPresented {
          hide()
        }
      }
    )
  }
  
  var tripItem: Binding<TripItem?> {
    .init(
      get: {
        if case let .presented(tripItem, _) = wrappedValue {
          tripItem
        } else {
          nil
        }
      },
      set: { tripItem in
        if case let .presented(_, hide) = wrappedValue, tripItem == nil {
          hide()
        }
      }
    )
  }
  
  var tripItemValue: TripItem? {
    tripItem.wrappedValue
  }
}
