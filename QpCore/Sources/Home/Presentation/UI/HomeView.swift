import Design
import Provider
import SwiftUI
import TripListPresentation

public struct HomeView: View {
  
  public init() {}

  public var body: some View {
    TripList(viewModel: getProvider().get())
  }
}

#Preview {
  getProvider()
    .register { TripListViewModel.samples.content }
  return HomeView()
}
