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

  private var renameBinding: Binding<EditTripRequestBindingValue> {
    state.request.bindRename { send(.handleRequest(nil)) }
  }
  
  private var setCategoryBinding: Binding<EditTripRequestBindingValue> {
    state.request.bindSetCategory { send(.handleRequest(nil)) }
  }
  
  private var setNotesBinding: Binding<EditTripRequestBindingValue> {
    state.request.bindSetNotes { send(.handleRequest(nil)) }
  }
  
  private let scrollTarget = "target"
  @State private var showSetReminder = false
  @State private var newName = ""
  @State private var newNotes = ""

  private var reminderButton: some View {
    Button {
      send(.requestNotificationsAuthorization)
      showSetReminder = true
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
            showSetReminder = false
          } label: {
            Label("Remove", systemSymbol: .trash)
          }
          .tint(.red)
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
          request: { send(.handleRequest($0)) }
        )
      }
      .alert(
        "Rename",
        isPresented: renameBinding.isPresented,
        presenting: renameBinding.tripItemValue
      ) { tripItem in
        TextField("New name", text: $newName)
        Button("Cancel") { send(.handleRequest(nil)) }
        Button("OK") { send(.updateItemName(tripItem.item.id, newName)) }
      } message: { tripItem in
        Text("Rename \(tripItem.item.name)")
      }
      .alert(
        "Set notes",
        isPresented: setNotesBinding.isPresented,
        presenting: setNotesBinding.tripItemValue
      ) { tripItem in
        TextField("Notes", text: $newNotes)
        Button("Cancel") { send(.handleRequest(nil)) }
        Button("OK") { send(.updateItemNotes(tripItem.id, newNotes)) }
      } message: { tripItem in
        Text("Set notes for \(tripItem.item.name)")
      }
      .sheet(item: setCategoryBinding.tripItem) { tripItem in categorySheet(tripItem: tripItem)  }
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
    .onChange(of: state.request) {
      newName = state.request.tripItem?.item.name ?? ""
      newNotes = state.request.tripItem?.notes ?? ""
    }
  }
  
  private func categorySheet(tripItem: TripItem) -> some View {
    NavigationStack {
      SetCategorySheetContent(
        currentCategory: tripItem.item.category,
        allCategories: state.allCategories,
        onCategoryChange: { newCategory in
          send(.updateItemCategory(tripItem, newCategory))
        }
      )
      .navigationTitle("Set category for \(tripItem.item.name)")
      .toolbarTitleDisplayMode(.inline)
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
