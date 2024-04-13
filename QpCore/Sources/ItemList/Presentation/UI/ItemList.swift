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
  }
}

private struct ItemListContent: View {
  let state: ItemListState
  let send: (ItemListAction) -> Void
  
  var body: some View {
    NavigationStack {
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
      .navigationTitle("My Items")
    }
  }
}

private struct ItemListItems: View {
  let items: [Item]
  let send: (ItemListAction) -> Void
  
  var body: some View {
    List(items) { item in
      HStack {
        Text(item.name)
      }
      .swipeActions(edge: .trailing) {
        Button {
          send(.delete(item.id))
        } label: {
          Label("Delete", systemSymbol: .trash)
            .tint(.red)
        }
      }
    }
    .animation(.default, value: items)
  }
}

#Preview {
  ItemListContent(
    state: .samples.content,
    send: { _ in }
  )
}
