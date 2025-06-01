import Design
import ItemDomain
import Provider
import QpUtils
import SFSafeSymbols
import SwiftUI
import TripDomain

public struct EditTrip: View {
  @ObservedObject private var viewModel: EditTripViewModel
  
  public init(viewModel: EditTripViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    EditTripContent(
      state: viewModel.state,
      send: viewModel.send
    )
  }
}

private struct EditTripContent: View {
  let state: EditTripState
  let send: (EditTripAction) -> Void
  
  private var nameBinding: Binding<String> {
    Binding(
      get: { state.name },
      set: { newName in
        if newName != state.name {
          send(.updateName(newName))
        }
      }
    )
  }
  private var searchBinding: Binding< String> {
    Binding(
      get: { state.searchQuery },
      set: { newQuery in
        if newQuery != state.searchQuery {
          send(.searchItem(newQuery))
        }
      }
    )
  }
  private var requestBinding: Binding<EditTripRequest?> {
     Binding(
       get: { state.request },
       set: { new in send(.handleRequest(new)) }
     )
   }
  @FocusState private var isRenameFocused: Bool
  @FocusState private var isNotesFocused: Bool
  private let scrollTarget = "target"

  private var reminderButton: some View {
    Button {
      send(.requestNotificationsAuthorization)
      send(.handleRequest(.showReminder))
    } label: {
      if let reminder = state.reminder {
        let text = reminder.formatted(
          Date.FormatStyle()
            .month(.abbreviated)
            .day(.defaultDigits)
            .hour(.defaultDigits(amPM: .abbreviated))
            .minute(.defaultDigits)
        )
        Label(text, systemSymbol: .alarm)
          .font(.footnote)
          .labelStyle(.titleAndIcon)
      } else {
        Image(systemSymbol: .alarm)
      }
    }
    .buttonStyle(BorderedButtonStyle())
  }

  private var reminderSheet: some View {
    let dateBinding = Binding(
      get: { state.reminder ?? Date.now },
      set: { send(.updateReminder($0)) }
    )
    return NavigationStack {
      Form {
        DatePicker("Time", selection: dateBinding, displayedComponents: [.date, .hourAndMinute])
      }
      .navigationTitle("Set reminder")
      .toolbar {
        ToolbarItem(placement: .automatic) {
          Button {
            send(.updateReminder(nil))
            send(.handleRequest(nil))
          } label: {
            Label("Remove", systemSymbol: .trash)
          }
          .tint(.red)
        }
      }
    }
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
  }
  
  var headerSection: some View {
    Section {
      TextField(text: nameBinding, prompt: Text("Required")) {
        Text("Name")
      }
      TripDatePicker(
        "Date",
        tripDate: state.date,
        onChange: { send(.updateDate($0)) }
      )
    }
  }

  var body: some View {
    ScrollViewReader { reader in
      List {
        headerSection
        addItemsSections(reader: reader)
        TripItems(
          categories: state.categories,
          send: send,
          request: { send(.handleRequest($0)) }
        )
      }
      .sheet(
        isPresented: requestBinding.isShowAllItems,
        onDismiss: { requestBinding.wrappedValue = nil }
      ) { allItemsSheet(items: state.searchItems.all) }
      .sheet(
        item: requestBinding.setCategoryItem,
        onDismiss: { requestBinding.wrappedValue = nil }
      ) { tripItem in categorySheet(tripItem: tripItem)  }
      .sheet(
        isPresented: requestBinding.isReminder,
        onDismiss: { requestBinding.wrappedValue = nil }
      ) { reminderSheet }
      .sheet(
        item: requestBinding.setNotesItem,
        onDismiss: { requestBinding.wrappedValue = nil }
      ) { tripItem in notesSheet(tripItem: tripItem) }
      .sheet(
        item: requestBinding.renameItem,
        onDismiss: { requestBinding.wrappedValue = nil }
      ) { tripItem in renameSheet(tripItem: tripItem) }
#if !os(macOS)
      .environment(\.editMode, .constant(.active))
#endif
      .animation(.default, value: state.categories)
      .animation(.default, value: state.searchQuery)
      .animation(.default, value: state.searchItems)
    }
    .navigationTitle("Edit trip")
    .toolbar {
      ToolbarItem(placement: .automatic) {
        reminderButton
      }
    }
    .scrollDismissesKeyboard(.interactively)
  }
  
  private func addItemsSections(reader: ScrollViewProxy) -> some View {
    Section("Add item") {
      HStack {
        Image(systemSymbol: .magnifyingglass)
        TextField("Search Item", text: searchBinding)
          .onChange(of: state.searchQuery) {
            withAnimation { reader.scrollTo(scrollTarget) }
          }
          .onSubmit { send(.addNewItem(name: state.searchQuery)) }
      }
      if state.searchItems.isNotEmpty {
        SearchItemResult(
          items: state.searchItems.filtered,
          showTimesUsed: false,
          send: send
        )
        if state.searchItems.hasMore {
          Button { send(.handleRequest(.showAllItems)) } label: {
            Text("See all")
          }
        }
      }
      if state.canCreateItem {
        Button { send(.addNewItem(name: state.searchQuery)) } label: {
          Text("Create '\(state.searchQuery)'")
        }
        .id(scrollTarget)
      }
    }
  }
  
  private func allItemsSheet(items: [Item]) -> some View {
    NavigationStack {
      List {
        SearchItemResult(
          items: items,
          showTimesUsed: true,
          send: send
        )
      }
      .navigationTitle("Add items")
      .toolbarTitleDisplayMode(.inline)
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }
  
  private func categorySheet(tripItem: TripItem) -> some View {
    NavigationStack {
      SetCategorySheetContent(
        currentCategory: tripItem.item.category,
        allCategories: state.allCategories,
        onCategoryChange: { newCategory in
          send(.updateItemCategory(tripItem, newCategory))
          send(.handleRequest(nil))
        }
      )
      .navigationTitle("Set category for \(tripItem.item.name)")
      .toolbarTitleDisplayMode(.inline)
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }
  
  private func notesSheet(tripItem: TripItem) -> some View {
    NavigationStack {
      Form {
        TextField("Notes", text: requestBinding.notesText)
          .focused($isNotesFocused)
      }
      .navigationTitle("Set notes for \(tripItem.item.name)")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { requestBinding.wrappedValue = nil }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            let notes = requestBinding.notesText.wrappedValue
            requestBinding.wrappedValue = nil
            send(.updateItemNotes(tripItem.id, notes))
          }
        }
      }
    }
    .presentationDetents([.medium])
  }
  
  private func renameSheet(tripItem: TripItem) -> some View {
    NavigationStack {
      Form {
        TextField("Name", text: requestBinding.renameText)
          .focused($isRenameFocused)
      }
      .navigationTitle("Rename \(tripItem.item.name)")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { requestBinding.wrappedValue = nil }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            let newName = requestBinding.renameText.wrappedValue
            requestBinding.wrappedValue = nil
            send(.updateItemName(tripItem.item.id, newName))
          }
        }
      }
    }
    .presentationDetents([.medium])
  }
  
}

#Preview("No search") {
  NavigationStack {
    EditTripContent(
      state: .samples.noSearch,
      send: { _ in }
    )
  }
}

#Preview("With search") {
  NavigationStack {
    EditTripContent(
      state: .samples.withSearch,
      send: { _ in }
    )
  }
}
