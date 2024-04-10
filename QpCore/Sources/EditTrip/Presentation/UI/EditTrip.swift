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
      },
      onDateChange: { newDate in
        viewModel.send(.updateDate(newDate: newDate))
      }
    )
  }
}

private struct EditTripContent: View {
  private let state: EditTripState
  private let onNameChange: (String) -> Void
  private let onDateChange: (Date) -> Void
    
  init(
    _ state: EditTripState,
    onNameChange: @escaping (String) -> Void,
    onDateChange: @escaping (Date) -> Void
  ) {
    self.state = state
    self.onNameChange = onNameChange
    self.onDateChange = onDateChange
  }
  
  var body: some View {
    let nameBinding = Binding(
      get: { state.name },
      set: { newName in
        if newName != state.name {
          onNameChange(newName)
        }
      }
    )
    let dateBinding = Binding(
      get: { state.date?.value ?? .now },
      set: { newDate in
        if newDate != state.date?.value {
          onDateChange(newDate)
        }
      }
    )
    VStack {
      Form {
        TextField(text: nameBinding, prompt: Text("Required")) {
          Text("Name")
        }
        DatePicker("Date", selection: dateBinding, displayedComponents: .date)
      }
    }
    .navigationTitle("Edit trip")
  }
}

#Preview {
  EditTripContent(
    .samples.malaysia,
    onNameChange: { _ in },
    onDateChange: { _ in }
  )
}
