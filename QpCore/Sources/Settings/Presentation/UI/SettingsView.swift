import CategoryListPresentation
import Design
import ItemListPresentation
import SwiftUI

public struct SettingsView: View {
  private let viewModel: SettingsViewModel
  
  public init(viewModel: SettingsViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    SettingsContent(
      state: viewModel.state,
      itemListViewModel: viewModel.itemListViewModel,
      categoryListViewModel: viewModel.categoryListViewModel
    )
  }
}

private struct SettingsContent: View {
  let state: SettingsState
  let itemListViewModel: ItemListViewModel
  let categoryListViewModel: CategoryListViewModel
  
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
        
        Section("Items and Categories") {
          NavigationLink("Items") {
            ItemList(viewModel: itemListViewModel)
              .navigationTitle("Items")
          }
          NavigationLink("Categories") {
            CategoryList(viewModel: categoryListViewModel)
              .navigationTitle("Categories")
          }
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
    itemListViewModel: FakeItemListViewModel(),
    categoryListViewModel: FakeCategoryListViewModel()
  )
}

#Preview("Error") {
  SettingsContent(
    state: .samples.error,
    itemListViewModel: FakeItemListViewModel(),
    categoryListViewModel: FakeCategoryListViewModel()
  )
}
