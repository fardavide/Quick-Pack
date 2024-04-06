import SwiftUI
import TripListPresentation

public struct HomeView: View {
  
  public init() {}

  public var body: some View {
    NavigationSplitView {
      TripList()
    } detail: {
      Text("Select an item")
    }
  }
}

#Preview {
  HomeView()
}
