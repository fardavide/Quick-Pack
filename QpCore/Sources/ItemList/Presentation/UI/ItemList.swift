import Design
import ItemDomain
import SwiftUI

public struct ItemList: View {
  @ObservedObject var viewModel: ItemListViewModel
  
  public init(viewModel: ItemListViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    ItemListContent(
      state: viewModel.state,
      send: viewModel.send
    )
    .undoable(with: viewModel.undoHandler)
  }
}

private struct ItemListContent: View {
  let state: ItemListState
  let send: (ItemListAction) -> Void
  
  var body: some View {
    LceView(
      lce: state.items,
      errorMessage: "Cannot load items"
    ) { items in
      if !items.isEmpty {
        ItemListItems(
          items: items,
          send: send
        )
      } else {
        SpecialCaseView.primary(
          title: "No item found",
          subtitle: "Create your first item from a trip",
          image: .macbookAndIphone
        )
      }
    }
  }
}

private struct ItemListItems: View {
  let items: [Item]
  let send: (ItemListAction) -> Void
  
  @State private var isRenamingItem: Bool = false
  @State private var renamingItem: Item?
  @State private var newName = ""
  
  var body: some View {
    List(items) { item in
      HStack {
        Text(item.name)
      }
      .swipeActions(edge: .trailing) {
        Button { 
          newName = item.name
          renamingItem = item
          isRenamingItem = true
        } label: {
          Label("Edit", systemSymbol: .pencil)
            .tint(.accentColor)
        }
        Button { send(.delete(item.id)) } label: {
          Label("Delete", systemSymbol: .trash)
            .tint(.red)
        }
      }
    }
    .animation(.default, value: items)
    .alert(
      "Rename \(renamingItem?.name ?? "item")",
      isPresented: $isRenamingItem,
      presenting: renamingItem
    ) { item in
      TextField("New name", text: $newName)
      Button("Cancel") {
        isRenamingItem = false
      }
      Button("OK") {
        send(.updateName(item.id, newName))
      }
    }
  }
}

#Preview {
  ItemListContent(
    state: .samples.content,
    send: { _ in }
  )
}
