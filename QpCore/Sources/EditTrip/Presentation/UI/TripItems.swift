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
  
  @State private var showRename: Bool = false
  @State private var showSetCategory: Bool = false
  @State private var showSetNotes: Bool = false
  
  @State private var newName = ""
  @State private var newNotes = ""

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
      HStack {
        Text(tripItem.item.name)
          .tint(.primary)
        Text(tripItem.notes)
          .tint(.secondary)
          .font(.caption)
      }
    }
    .contentShape(Rectangle())
    .toggleStyle(CheckboxToggleStyle())
    .contextMenu {
      
      Section("Edit item for this trip") {
        
        Button {
          showSetNotes = true
          newNotes = tripItem.notes
        } label: {
          Label("Set notes", systemSymbol: .noteText)
            .tint(.accentColor)
        }
      }
      
      Section("Edit item") {
        
        Button { showSetCategory = true } label: {
          Label("Set category", systemSymbol: .rectangleAndPencilAndEllipsis)
            .tint(.accentColor)
        }
        
        Button {
          showRename = true
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
    }
    .swipeActions(edge: .trailing) {
      Button { send(.removeItem(tripItem.id)) } label: {
        Label("Remove item", systemSymbol: .xmark)
          .tint(.accentColor)
      }
    }
    .alert("Rename \(tripItem.item.name)", isPresented: $showRename) {
      TextField("New name", text: $newName)
      Button("Cancel") { showRename = false }
      Button("OK") { send(.updateItemName(tripItem.item.id, newName)) }
    }
    .alert("Set notes for \(tripItem.item.name)", isPresented: $showSetNotes) {
      TextField("Notes", text: $newNotes)
      Button("Cancel") { showSetNotes = false }
      Button("OK") { send(.updateItemNotes(tripItem.id, newNotes)) }
    }
    .sheet(isPresented: $showSetCategory) {
      NavigationStack {
        SetCategorySheetContent(
          currentCategory: tripItem.item.category,
          allCategories: allCategories,
          onCategoryChange: { newCategory in
            send(.updateItemCategory(tripItem, newCategory))
            showSetCategory = false
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
