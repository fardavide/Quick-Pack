import Design
import Provider
import SwiftUI

public struct TripList: View {
  @StateObject var viewModel: TripListViewModel = getProvider().get()
  
  public init() {}
  
  public var body: some View {
    TripListContent(viewModel.state)
  }
}

private struct TripListContent: View {
  
  private let state: TripListState
  
  init(_ state: TripListState) {
    self.state = state
  }
  
  public var body: some View {
    LceView(
      lce: state.trips,
      errorMessage: "Cannot load trips",
      content: { items in
        if !items.isEmpty {
          TripListItems(items: items)
        } else {
          SpecialCaseView.zero(
            title: "No trip found",
            subtitle: "Create your first trip",
            image: .backpack,
            actionText: "Create trip",
            action: {
              
            }
          )
        }
      }
    )
  }
}

private struct TripListItems: View {
  let items: [TripListItemUiModel]
  
  var body: some View {
    List(items) { item in
      HStack {
        // NavigationLink {
        Text(item.name)
        Spacer()
        if let date = item.date {
          Text(date)
        }
        // label: {
        // Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
        // }
      }
      // .onDelete(perform: deleteItems)
    }
#if os(macOS)
    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    .toolbar {
#if os(iOS)
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
#endif
      // ToolbarItem {
      //   Button(action: addItem) {
      //     Label("Add Item", systemImage: "plus")
      //   }
      // }
    }
  }
}

#Preview("With items") {
  TripListContent(.samples.content)
}

#Preview("Zero") {
  TripListContent(.samples.empty)
}
