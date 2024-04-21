import ItemDomain
import Presentation
import SwiftUI
import TripDomain

struct TripItemList: View {
  let categories: [ItemCategoryUiModel]
  let allCategories: DataLce<[ItemCategory]>
  let send: (EditTripAction) -> Void

  public var body: some View {
    List {
      ForEach(categories) { uiModel in
        CategorySection(
          uiModel: uiModel,
          allCategories: allCategories,
          send: send
        )
      }
      .onMove { indices, newOffset in send(.reorderItems(from: indices, to: newOffset)) }
      .animation(.default, value: categories)
    }
  }
}

private struct CategorySection: View {
  let uiModel: ItemCategoryUiModel
  let allCategories: DataLce<[ItemCategory]>
  let send: (EditTripAction) -> Void

  @State var isExpanded: Bool = true

  var body: some View {
    Section(isExpanded: $isExpanded) {
      ForEach(uiModel.items) { tripItem in
        TripItemView(
          tripItem: tripItem,
          allCategories: allCategories,
          send: send
        )
      }
    } header: {
      HStack {
        Text(uiModel.category?.name ?? "Items")
        Spacer()
        Image(systemSymbol: .chevronDown)
      }
      .contentShape(Rectangle())
      .onTapGesture { isExpanded = !isExpanded }
    }
    .animation(.default, value: uiModel)
    .animation(.default, value: isExpanded)
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
    HStack {
      Toggle(isOn: isCheckedBinding) {
        Text(tripItem.item.name).tint(.primary)
      }
      Spacer()
      Image(systemSymbol: .line3Horizontal)
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
      SetCategorySheetContent(
        currentCategory: tripItem.item.category,
        allCategories: allCategories,
        onCategoryChange: { newCategory in
          send(.updateItemCategory(tripItem, newCategory))
          showSetCategorySheet = false
        }
      )
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
    categories: [
      ItemCategoryUiModel.samples.tech,
      ItemCategoryUiModel.samples.clothes
    ],
    allCategories: .loading,
    send: { _ in }
  )
}
