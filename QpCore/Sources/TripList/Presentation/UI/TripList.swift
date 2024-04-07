import Design
import Provider
import SwiftUI

public struct TripList: View {
  @StateObject var viewModel: TripListViewModel = getProvider().get()
  
  public init() {}
  
  public var body: some View {
    LceView(
      lce: viewModel.state.trips,
      errorMessage: "Cannot load trips",
      content: { items in
        TripListContent(items: items)
      }
    )
  }
}

private struct TripListContent: View {
  let items: [TripListItemUiModel]
  
  var body: some View {
    List(items) { item in
      VStack {
        // NavigationLink {
        Text(item.name)
        if let date = item.date {
          Text(date)
        }
        // } label: {
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

#Preview {
  TripListContent(items: [TripListItemUiModel.samples.malaysia])
}
