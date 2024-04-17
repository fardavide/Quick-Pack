import ItemDomain
import SwiftUI
import TripDomain

struct TripItemList: View {
  let items: [TripItem]
  let send: (EditTripAction) -> Void
    
  @State var isEditingItem: Bool = false
  @State private var newName = ""
  
  public var body: some View {
    List {
      ForEach(items) { tripItem in
        let isCheckedBinding = Binding(
          get: { tripItem.isChecked },
          set: { newIsChecked in
            if newIsChecked != tripItem.isChecked {
              send(.updateItemCheck(tripItem.id, newIsChecked))
            }
          }
        )
        HStack {
          Toggle(isOn: isCheckedBinding) {
            Text(tripItem.item.name).tint(.primary)
          }
          Spacer()
          Image(systemSymbol: .line3Horizontal)
        }
        .toggleStyle(CheckboxToggleStyle())
        .contextMenu {
          Button {
            isEditingItem = true
            newName = tripItem.item.name
          } label: {
            Label("Rename", systemSymbol: .pencil)
              .tint(.accentColor)
          }
          Button { send(.deleteItem(tripItem.item.id)) } label: {
            Label("Delete", systemSymbol: .trash)
              .tint(.red)
          }
        }
        .alert("Rename \(tripItem.item.name)", isPresented: $isEditingItem) {
          TextField("New name", text: $newName)
          Button("OK") {
            send(.updateItemName(tripItem.item.id, newName))
          }
        }
        .swipeActions(edge: .trailing) {
          Button { send(.removeItem(tripItem.id)) } label: {
            Label("Remove item", systemSymbol: .xmark)
              .tint(.accentColor)
          }
        }
      }
      .onMove { indices, newOffset in send(.reorderItems(from: indices, to: newOffset)) }
      .animation(.default, value: items)
    }
  }
}

private struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button { configuration.isOn.toggle() } label: {
      HStack {
        Image(systemSymbol: configuration.isOn ? .checkmarkSquareFill : .square)
          .font(.title2)
          .symbolEffect(.bounce, value: configuration.isOn)
        configuration.label
      }
    }
  }
}

#Preview {
  TripItemList(
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch.withCheck()
    ],
    send: { _ in }
  )
}
