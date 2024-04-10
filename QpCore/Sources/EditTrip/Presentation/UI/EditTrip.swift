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
      onNameChange: { newName in
        viewModel.send(.updateName(newName: newName))
      }
    )
  }
}

private struct EditTripContent: View {
  private let state: EditTripState
  private let onNameChange: (String) -> Void
    
  init(
    _ state: EditTripState,
    onNameChange: @escaping (String) -> Void
  ) {
    self.state = state
    self.onNameChange = onNameChange
  }
  
  var body: some View {
    let textFieldBinding = Binding(
      get: { state.name },
      set: { newName in
        if newName != state.name {
          onNameChange(newName)
        }
      }
    )
    VStack {
      Form {
        TextField(text: textFieldBinding, prompt: Text("Required")) {
          Text("Name")
        }
      }
    }
    .navigationTitle("Edit trip")
  }
}

#Preview {
  EditTripContent(
    .samples.malaysia,
    onNameChange: { _ in }
  )
}
