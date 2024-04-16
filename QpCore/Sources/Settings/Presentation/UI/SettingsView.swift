import Design
import ItemListPresentation
import SwiftUI

public struct SettingsView: View {
  private let viewModel: SettingsViewModel
  
  public init(viewModel: SettingsViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    SettingsContent(state: viewModel.state, itemListViewModel: viewModel.itemListViewModel)
  }
}

private struct SettingsContent: View {
  let state: SettingsState
  let itemListViewModel: ItemListViewModel
  
  var body: some View {
    NavigationStack {
      Form {
        Section("App info") {
          LceView(
            lce: state.appVersion,
            errorMessage: "Cannot get app version"
          ) { appVersion in
            Text("Version \(appVersion)")
          }
        }
        
        Section("My items") {
          ItemList(viewModel: itemListViewModel)
        }
      }
      .navigationTitle("Settings")
      .toolbar {
#if os(iOS)
        let ghPlacement: ToolbarItemPlacement = .bottomBar
#else
        let ghPlacement: ToolbarItemPlacement = .automatic
#endif
        ToolbarItem(placement: ghPlacement) {
          Link(destination: URL(string: "https://github.com/fardavide/Quick-Pack")!) {
            HStack {
              Image(asset: .gitHub)
                .resizable()
                .scaledToFit()
                .frame(height: 25)
              Image(systemSymbol: .starFill)
                .symbolRenderingMode(.multicolor)
                .symbolEffect(.pulse)
            }
          }
        }
      }
    }
  }
}

#Preview("Success") {
  SettingsContent(
    state: .samples.content,
    itemListViewModel: FakeItemListViewModel()
  )
}

#Preview("Error") {
  SettingsContent(
    state: .samples.error,
    itemListViewModel: FakeItemListViewModel()
  )
}
