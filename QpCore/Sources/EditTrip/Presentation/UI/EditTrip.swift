import Design
import Provider
import QpUtils
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
          if state.searchQuery.isNotBlank {
            Button { send(.addNewItem(name: state.searchQuery)) } label: {
              Text("Create '\(state.searchQuery)'")
            }
            .id(scrollTarget)
          }
        }
        
        TripItems(
          categories: state.categories,
          allCategories: state.allCategories,
          send: send
        )
        .animation(.default, value: state.categories)
      }
      #if !os(macOS)
      .environment(\.editMode, .constant(.active))
      #endif
      .animation(.default, value: state.categories)
      .animation(.default, value: state.searchQuery)
      .animation(.default, value: state.searchItems)
    }
    .navigationTitle("Edit trip")
    .scrollDismissesKeyboard(.interactively)
  }
}

#Preview("No search") {
  EditTripContent(
    state: .samples.noSearch,
    send: { _ in }
  )
}

#Preview("With search") {
  EditTripContent(
    state: .samples.withSearch,
    send: { _ in }
  )
}
