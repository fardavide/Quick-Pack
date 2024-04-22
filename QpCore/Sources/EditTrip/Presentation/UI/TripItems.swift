import CategoryDomain
import ItemDomain
import Presentation
import SwiftUI
import TripDomain

struct TripItems: View {
  let categories: [ItemCategoryUiModel]
  let allCategories: DataLce<[ItemCategory]>
  let send: (EditTripAction) -> Void
    
  public var body: some View {
    ForEach(categories) { uiModel in
      CategoryGroup(
        uiModel: uiModel,
        allCategories: allCategories,
        send: send
      )
    }
    .animation(.default, value: categories)
  }
}

private struct CategoryGroup: View {
  let uiModel: ItemCategoryUiModel
  let allCategories: DataLce<[ItemCategory]>
  let send: (EditTripAction) -> Void

  @State var isExpanded: Bool = true

  var body: some View {
    DisclosureGroup(isExpanded: $isExpanded) {
      ForEach(uiModel.items) { tripItem in
        TripItemView(
          tripItem: tripItem,
          allCategories: allCategories,
          send: send
        )
      }
      .onMove { indices, newOffset in
        send(.reorderItems(for: uiModel.category?.id, from: indices, to: newOffset))
      }
    } label: {
      HStack {
        if let categoryName = uiModel.category?.name {
          Text(categoryName)
          if !isExpanded {
            Text(uiModel.itemsSummary)
              .font(.caption)
          }
        } else {
          Text(uiModel.itemsSummary)
        }
      }
    }
    .animation(.default, value: uiModel)
  }
}

private struct TripItemView: View {
  let tripItem: TripItem
  let allCategories: DataLce<[ItemCategory]>
  let send: (EditTripAction) -> Void
  
  @State var showRenameAlert: Bool = false
  @State var showSetCategorySheet: Bool = false
  
  @State private var newName = ""

  var body: some View {
    let isCheckedBinding = Binding(
      get: { tripItem.isChecked },
      set: { newIsChecked in
        if newIsChecked != tripItem.isChecked {
          send(.updateItemCheck(tripItem.id, newIsChecked))
        }
      }
    )
    Toggle(isOn: isCheckedBinding) {
      Text(tripItem.item.name).tint(.primary)
    }
    .contentShape(Rectangle())
    .toggleStyle(CheckboxToggleStyle())
    .contextMenu {
      Button { showSetCategorySheet = true } label: {
        Label("Set category", systemSymbol: .rectangleAndPencilAndEllipsis)
          .tint(.accentColor)
      }
      Button {
        showRenameAlert = true
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
    .swipeActions(edge: .trailing) {
      Button { send(.removeItem(tripItem.id)) } label: {
        Label("Remove item", systemSymbol: .xmark)
          .tint(.accentColor)
      }
    }
    .alert("Rename \(tripItem.item.name)", isPresented: $showRenameAlert) {
      TextField("New name", text: $newName)
      Button("Cancel") { showRenameAlert = false }
      Button("OK") { send(.updateItemName(tripItem.item.id, newName)) }
    }
    .sheet(isPresented: $showSetCategorySheet) {
      NavigationStack {
        SetCategorySheetContent(
          currentCategory: tripItem.item.category,
          allCategories: allCategories,
          onCategoryChange: { newCategory in
            send(.updateItemCategory(tripItem, newCategory))
            showSetCategorySheet = false
          }
        )
        .navigationTitle("Set category for \(tripItem.item.name)")
      }
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
  List {
    TripItems(
      categories: [
        ItemCategoryUiModel.samples.tech,
        ItemCategoryUiModel.samples.clothes,
        ItemCategoryUiModel.samples.noCategory
      ],
      allCategories: .loading,
      send: { _ in }
    )
  }
}
