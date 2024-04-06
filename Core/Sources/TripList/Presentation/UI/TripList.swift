import Provider
import SwiftUI

public struct TripList: View {
  @StateObject var viewModel: TripListViewModel = getProvider().get()
  
  public init() {}
  
  public var body: some View {
    switch viewModel.state.trips {
    case let .content(items): TripListContent(items: items)
    case .error: Text("error")
    case .loading: Text("loading")
    }
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
          Text(date, format: Date.FormatStyle(date: .numeric, time: .standard))
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
