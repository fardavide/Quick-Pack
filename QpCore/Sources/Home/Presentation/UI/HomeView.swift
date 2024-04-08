import Design
import SwiftUI
import TripListPresentation

public struct HomeView: View {
  
  public init() {}

  public var body: some View {
    NavigationSplitView {
      TripList()
    } detail: {
      SpecialCaseView.primary(
        title: "Select a trip",
        image: .backpack
      )
    }
  }
}

#Preview {
  HomeView()
}
