import Design
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
  
  private let scrollTarget = "target"
  @State private var editingTripItem: TripItem?
  @State private var showRename = false
  @State private var showSetCategory = false
  @State private var showSetNotes = false
  @State private var showSetReminder = false
  @State private var newName = ""
  @State private var newNotes = ""

  private var reminderButton: some View {
    Button { showSetReminder = true } label: {
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

  private var categorySheet: some View {
    NavigationStack {
      SetCategorySheetContent(
        currentCategory: editingTripItem!.item.category,
        allCategories: state.allCategories,
        onCategoryChange: { newCategory in
          send(.updateItemCategory(editingTripItem!, newCategory))
        }
      )
      .navigationTitle("Set category for \(editingTripItem!.item.name)")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button { showSetCategory = false } label: {
            Label("Close", systemSymbol: .arrowBackward)
          }
          .tint(.secondary)
        }
      }
    }
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
            showSetReminder = false
          } label: {
            Label("Remove", systemSymbol: .trash)
          }
          .tint(.red)
        }
        ToolbarItem(placement: .topBarLeading) {
          Button { showSetReminder = false } label: {
            Label("Close", systemSymbol: .arrowBackward)
          }
          .tint(.secondary)
        }
      }
    }
    .presentationDetents([.medium])
  }

  var body: some View {
    let nameBinding = Binding(
      get: { state.name },
      set: { newName in
        if newName != state.name {
          send(.updateName(newName))
        }
      }
    )
    let searchBinding = Binding(
      get: { state.searchQuery },
      set: { newQuery in
        if newQuery != state.searchQuery {
          send(.searchItem(newQuery))
        }
      }
    )
    ScrollViewReader { reader in
      List {
        
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
              items: state.searchItems,
              send: send
            )
          }
          if state.canCreateItem {
            Button { send(.addNewItem(name: state.searchQuery)) } label: {
              Text("Create '\(state.searchQuery)'")
            }
            .id(scrollTarget)
          }
        }
        
        TripItems(
          categories: state.categories,
          send: send,
          request: handleRequest
        )
      }
      .alert("Rename", isPresented: $showRename, presenting: editingTripItem) { tripItem in
        TextField("New name", text: $newName)
        Button("Cancel") { showRename = false }
        Button("OK") { send(.updateItemName(tripItem.item.id, newName)) }
      } message: { tripItem in
        Text("Rename \(tripItem.item.name)")
      }
      .alert("Set notes", isPresented: $showSetNotes, presenting: editingTripItem) { tripItem in
        TextField("Notes", text: $newNotes)
        Button("Cancel") { showSetNotes = false }
        Button("OK") { send(.updateItemNotes(tripItem.id, newNotes)) }
      } message: { tripItem in
        Text("Set notes for \(tripItem.item.name)")
      }
      .sheet(isPresented: $showSetCategory) { categorySheet }
      .sheet(isPresented: $showSetReminder) { reminderSheet }
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
  
  private func handleRequest(_ request: EditTripRequest) {
    switch request {
    case let .showRename(tripItem):
      editingTripItem = tripItem
      newName = tripItem.item.name
      showRename = true
    case let .showSetCategory(tripItem):
      editingTripItem = tripItem
      showSetCategory = true
    case let .showSetNotes(tripItem):
      editingTripItem = tripItem
      newNotes = tripItem.notes
      showSetNotes = true
    }
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
