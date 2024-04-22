import CategoryDomain
import Design
import SwiftUI

public struct CategoryList: View {
  @ObservedObject var viewModel: CategoryListViewModel
  
  public init(viewModel: CategoryListViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    CategoryListContent(
      state: viewModel.state,
      send: viewModel.send
    )
    .undoable(with: viewModel.undoHandler)
  }
}

private struct CategoryListContent: View {
  let state: CategoryListState
  let send: (CategoryListAction) -> Void
  
  var body: some View {
    LceView(
      lce: state.categories,
      errorMessage: "Cannot load categories"
    ) { categories in
      if !categories.isEmpty {
        CategoryListItems(
          categories: categories,
          send: send
        )
      } else {
        SpecialCaseView.primary(
          title: "No category found",
          image: .shippingbox
        )
      }
    }
  }
}

private struct CategoryListItems: View {
  let categories: [ItemCategory]
  let send: (CategoryListAction) -> Void
  
  @State private var isRenamingCategory: Bool = false
  @State private var renamingCategory: ItemCategory?
  @State private var newName = ""
  
  var body: some View {
    List {
      ForEach(categories) { category in
        HStack {
          Text(category.name)
        }
        .swipeActions(edge: .trailing) {
          Button {
            newName = category.name
            renamingCategory = category
            isRenamingCategory = true
          } label: {
            Label("Edit", systemSymbol: .pencil)
              .tint(.accentColor)
          }
          Button { send(.delete(category.id)) } label: {
            Label("Delete", systemSymbol: .trash)
              .tint(.red)
          }
        }
      }
      .onMove { indices, newOffset in
        send(.reorderCategories(from: indices, to: newOffset))
      }
    }
    #if !os(macOS)
    .environment(\.editMode, .constant(.active))
    #endif
    .animation(.default, value: categories)
    .alert(
      "Rename \(renamingCategory?.name ?? "category")",
      isPresented: $isRenamingCategory,
      presenting: renamingCategory
    ) { category in
      TextField("New name", text: $newName)
      Button("Cancel") {
        isRenamingCategory = false
      }
      Button("OK") {
        send(.updateName(category.id, newName))
      }
    }
  }
}

#Preview("content") {
  CategoryListContent(
    state: .samples.content,
    send: { _ in }
  )
}

#Preview("empty") {
  CategoryListContent(
    state: .samples.empty,
    send: { _ in }
  )
}
