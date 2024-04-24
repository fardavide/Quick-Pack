import ItemDomain
import Presentation
import SwiftUI
import TripDomain

struct TripItems: View {
  let categories: [ItemCategoryUiModel]
  let send: (EditTripAction) -> Void
  let request: (EditTripRequest) -> Void
    
  public var body: some View {
    ForEach(categories) { uiModel in
      CategoryGroup(
        uiModel: uiModel,
        send: send,
        request: request
      )
    }
    .animation(.default, value: categories)
  }
}

private struct CategoryGroup: View {
  let uiModel: ItemCategoryUiModel
  let send: (EditTripAction) -> Void
  let request: (EditTripRequest) -> Void

  @State var isExpanded: Bool = true

  var body: some View {
    DisclosureGroup(isExpanded: $isExpanded) {
      ForEach(uiModel.items) { tripItem in
        TripItemView(
          tripItem: tripItem,
          send: send,
          request: request
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
  let send: (EditTripAction) -> Void
  let request: (EditTripRequest) -> Void

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
          .font(.caption.weight(.light))
      }
    }
    .toggleStyle(CheckboxToggleStyle())
    .contextMenu {
      
      Section("Edit item for this trip") {
        
        Button { request(.showSetNotes(tripItem)) } label: {
          Label("Set notes", systemSymbol: .noteText)
            .tint(.accentColor)
        }
        
        Button { send(.removeItem(tripItem.id)) } label: {
          Label("Remove item", systemSymbol: .xmark)
            .tint(.accentColor)
        }
      }
      
      Section("Edit item") {
        
        Button { request(.showSetCategory(tripItem)) } label: {
          Label("Set category", systemSymbol: .rectangleAndPencilAndEllipsis)
            .tint(.accentColor)
        }
        
        Button { request(.showRename(tripItem)) } label: {
          Label("Rename", systemSymbol: .pencil)
            .tint(.accentColor)
        }
       
        Button { send(.deleteItem(tripItem.item.id)) } label: {
          Label("Delete", systemSymbol: .trash)
            .tint(.red)
        }
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
      send: { _ in },
      request: { _ in }
    )
  }
}
