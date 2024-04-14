import Design
import Provider
import SwiftUI
import TripDomain

public struct EditTrip: View {
  @ObservedObject var viewModel: EditTripViewModel
  
  public init(viewModel: EditTripViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    EditTripContent(
      viewModel.state,
      send: viewModel.send
    )
  }
}

private struct EditTripContent: View {
  private let state: EditTripState
  private let send: (EditTripAction) -> Void
  
  @FocusState private var isNameFocused: Bool
  @State private var searchQuery: String = ""
  
  init(
    _ state: EditTripState,
    send: @escaping (EditTripAction) -> Void
  ) {
    self.state = state
    self.send = send
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
    let dateBinding = Binding(
      get: { state.date?.value ?? .now },
      set: { newDate in
        if newDate != state.date?.value {
          send(.updateDate(newDate))
        }
      }
    )
    let searchBinding = Binding(
      get: { searchQuery },
      set: { newQuery in
        if newQuery != searchQuery {
          send(.searchItem(newQuery))
        }
      }
    )
    Form {
      
      Section {
        TextField(text: nameBinding, prompt: Text("Required")) {
          Text("Name")
        }
        .focused($isNameFocused)
        .onAppear { isNameFocused = true }
        DatePicker("Date", selection: dateBinding, displayedComponents: .date)
      }
      
      Section("Add item") {
        HStack {
          Image(systemSymbol: .magnifyingglass)
          TextField("Search Item", text: searchBinding)
        }
        SearchItemResult(
          items: state.searchItems,
          send: send
        )
      }
      
      Section("Items") {
        TripItemList(
          items: state.tripItems,
          send: send
        )
        .animation(.default, value: state.tripItems)
      }
    }
    .navigationTitle("Edit trip")
  }
}

#Preview("No search") {
  EditTripContent(
    .samples.noSearch,
    send: { _ in }
  )
}

#Preview("With search") {
  EditTripContent(
    .samples.withSearch,
    send: { _ in }
  )
}
