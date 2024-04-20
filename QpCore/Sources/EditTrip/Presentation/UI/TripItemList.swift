import ItemDomain
import SwiftUI
import TripDomain

struct TripItemList: View {
  let categories: [ItemCategoryUiModel]
  let send: (EditTripAction) -> Void
    

  public var body: some View {
    List {
      ForEach(categories) { uiModel in
        CategorySection(
          uiModel: uiModel,
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
  let send: (EditTripAction) -> Void

  @State var isExpanded: Bool = true

  var body: some View {
    Section(isExpanded: $isExpanded) {
      ForEach(uiModel.items) { tripItem in
        TripItemView(
          tripItem: tripItem,
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
  let send: (EditTripAction) -> Void
  
  @State var showRenameAlert: Bool = false
  @State var showChooseCategorySheet: Bool = false
  
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
    .alert("Rename \(tripItem.item.name)", isPresented: $showRenameAlert) {
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
    send: { _ in }
  )
}
