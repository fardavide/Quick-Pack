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
        DatePicker("Date", selection: dateBinding, displayedComponents: .date)
      }
      
      Section("Items") {
        TripItemList(
          items: state.items,
          onNameChange: { itemId, newName in send(.updateItemName(itemId, newName)) },
          onCheckChange: { itemId, newIsChecked in send(.updateItemCheck(itemId, newIsChecked)) },
          onRemove: { itemId in send(.removeItem(itemId)) }
        )
      }
    }
    .navigationTitle("Edit trip")
    .toolbar {
      Button { send(.addNewItem) } label: {
        Label("Add Item", systemImage: "plus")
      }
    }
  }
}

#Preview {
  EditTripContent(
    .samples.malaysia,
    send: { _ in }
  )
}
