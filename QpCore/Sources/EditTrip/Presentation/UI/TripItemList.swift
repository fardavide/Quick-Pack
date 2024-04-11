import ItemDomain
import SwiftUI

struct TripItemList: View {
  let items: [EditableTripItem]
  let onNameChange: (ItemId, String) -> Void
  let onCheckChange: (ItemId, Bool) -> Void
  let onRemove: (ItemId) -> Void
  
  public var body: some View {
    List(items) { item in
      let isCheckedBinding = Binding(
        get: { item.isChecked },
        set: { newIsChecked in
          if newIsChecked != item.isChecked {
            onCheckChange(item.itemId, newIsChecked)
          }
        }
      )
      let nameBinding = Binding(
        get: { item.name },
        set: { newName in
          if newName != item.name {
            onNameChange(item.itemId, newName)
          }
        }
      )
      Toggle(isOn: isCheckedBinding) {
        TextField("\(item.id)", text: nameBinding, prompt: Text("Item name"))
      }
      .toggleStyle(CheckboxToggleStyle())
      .swipeActions(edge: .trailing) {
        Button { onRemove(item.itemId) } label: {
          Label("Remove item", systemSymbol: .xmark)
            .tint(.accentColor)
        }
      }
    }
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
    onRemove: { _ in }
  )
}
