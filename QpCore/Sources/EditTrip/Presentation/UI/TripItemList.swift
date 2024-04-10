import ItemDomain
import SwiftUI

struct TripItemList: View {
  let items: [EditableTripItem]
  let onNameChange: (ItemId, String) -> Void
  let onRemove: (ItemId) -> Void
  
  public var body: some View {
    List(items) { item in
      let nameBinding = Binding(
        get: { item.name },
        set: { newName in
          if newName != item.name {
            onNameChange(item.itemId, newName)
          }
        }
      )
      TextField("\(item.id)", text: nameBinding, prompt: Text("Item name"))
        .swipeActions(edge: .trailing) {
          Button { onRemove(item.itemId) } label: {
            Label("Remove item", systemSymbol: .xmark)
              .tint(.accentColor)
          }
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
    onRemove: { _ in }
  )
}
