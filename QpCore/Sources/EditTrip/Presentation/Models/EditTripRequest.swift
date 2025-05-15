import ItemDomain
import SwiftUI
import TripDomain

public enum EditTripRequest: Equatable, Sendable {
    case showAllItems
    case showReminder
    case showRename(item: TripItem, name: String)
    case showSetCategory(item: TripItem)
    case showSetNotes(item: TripItem, notes: String)
}

extension Binding where Value == EditTripRequest? {
  var isRename: Binding<Bool> {
    .init(
      get: { if case .showRename = wrappedValue { true } else { false } },
      set: { if !$0 { wrappedValue = nil } }
    )
  }
  
  var isReminder: Binding<Bool> {
    .init(
      get: { if case .showReminder = wrappedValue { true } else { false } },
      set: { if !$0 { wrappedValue = nil } }
    )
  }
  
  var isSetCategory: Binding<Bool> {
    .init(
      get: { if case .showSetCategory = wrappedValue { true } else { false } },
      set: { if !$0 { wrappedValue = nil } }
    )
  }
  
  var isSetNotes: Binding<Bool> {
    .init(
      get: { if case .showSetNotes = wrappedValue { true } else { false } },
      set: { if !$0 { wrappedValue = nil } }
    )
  }
  
  var isShowAllItems: Binding<Bool> {
    .init(
      get: { if case .showAllItems = wrappedValue { true } else { false } },
      set: { if !$0 { wrappedValue = nil } }
    )
  }
  
  var notesText: Binding<String> {
    .init(
      get: { if case let .showSetNotes(_, notes) = wrappedValue { notes } else { "" } },
      set: { notes in
        if case let .showSetNotes(item, _) = wrappedValue {
          wrappedValue = .showSetNotes(item: item, notes: notes)
        }
      }
    )
  }
  
  var renameItem: TripItem? {
    if case let .showRename(item, _) = wrappedValue { item } else { nil }
  }
  
  var renameText: Binding<String> {
    .init(
      get: { if case let .showRename(_, name) = wrappedValue { name } else { "" } },
      set: { name in
        if case let .showRename(item, _) = wrappedValue {
          wrappedValue = .showRename(item: item, name: name)
        }
      }
    )
  }
  
  var setCategoryItem: Binding<TripItem?> {
    .init(
      get: { if case let .showSetCategory(item_) = wrappedValue { item_ } else { nil } },
      set: { item in
        if case let .showSetCategory(item_) = wrappedValue {
          wrappedValue = .showSetCategory(item: item ?? item_)
        }
      }
    )
  }
  
  var setNotesItem: TripItem? {
    if case let .showSetNotes(item, _) = wrappedValue { item } else { nil }
  }
}
