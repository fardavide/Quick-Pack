import ItemDomain
import SwiftUI
import TripDomain

struct TripItemList: View {
  let items: [EditableTripItem]
  let onNameChange: (TripItemId, String) -> Void
  let onCheckChange: (TripItemId, Bool) -> Void
  let onOrderChange: (IndexSet, Int) -> Void
  let onRemove: (TripItemId) -> Void
  
  @FocusState private var focusedItemId: TripItemId?
  
  public var body: some View {
    List {
      ForEach(items) { item in
        let isCheckedBinding = Binding(
          get: { item.isChecked },
          set: { newIsChecked in
            if newIsChecked != item.isChecked {
              onCheckChange(item.id, newIsChecked)
            }
          }
        )
        let nameBinding = Binding(
          get: { item.name },
          set: { newName in
            if newName != item.name {
              onNameChange(item.id, newName)
            }
          }
        )
        HStack {
          Toggle(isOn: isCheckedBinding) {
            TextField("\(item.id)", text: nameBinding, prompt: Text("Item name"))
              .focused($focusedItemId, equals: item.id)
          }
          Spacer()
          Image(systemSymbol: .line3Horizontal)
        }
        .toggleStyle(CheckboxToggleStyle())
        .swipeActions(edge: .trailing) {
          Button { onRemove(item.id) } label: {
            Label("Remove item", systemSymbol: .xmark)
              .tint(.accentColor)
          }
        }
        .onAppear {
          if nameBinding.wrappedValue.isEmpty {
            focusedItemId = item.id
          }
        }
      }
    }
    .animation(.default, value: items)
  }
}

private struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button { configuration.isOn.toggle() } label: {
      HStack {
        Image(systemSymbol: configuration.isOn ? .checkmarkSquare : .square)
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
      .samples.nintendoSwitch
    ],
    onNameChange: { _, _ in },
    onCheckChange: { _, _ in },
    onOrderChange: { _, _ in },
    onRemove: { _ in }
  )
}
