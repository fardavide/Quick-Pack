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
    Form {
      
      Section {
        TextField(text: nameBinding, prompt: Text("Required")) {
          Text("Name")
        }
        .focused($isNameFocused)
        .onAppear { isNameFocused = true }
        DatePicker("Date", selection: dateBinding, displayedComponents: .date)
      }
      
      Section {
        TripItemList(
          items: state.items,
          onNameChange: { itemId, newName in send(.updateItemName(itemId, newName)) },
          onCheckChange: { itemId, newIsChecked in send(.updateItemCheck(itemId, newIsChecked)) },
          onOrderChange: { from, to in send(.reorderItems(from: from, to: to)) },
          onRemove: { itemId in send(.removeItem(itemId)) }
        )
        .animation(.default, value: state.items)
      } header: {
        HStack {
          Text("Items")
          Spacer()
          Button { send(.addNewItem) } label: {
            Label("Add", systemSymbol: .plus)
              .labelStyle(.iconOnly)
          }
        }
      }
    }
    .navigationTitle("Edit trip")
  }
}

#Preview {
  EditTripContent(
    .samples.malaysia,
    send: { _ in }
  )
}
