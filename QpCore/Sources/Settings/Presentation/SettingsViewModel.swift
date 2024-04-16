import AboutDomain
import ItemListPresentation
import Presentation

public class SettingsViewModel: ViewModel {
  public typealias Action = SettingsAction
  public typealias State = SettingsState
  
  public let itemListViewModel: ItemListViewModel
  public let state: SettingsState
  
  init(
    itemListViewModel: ItemListViewModel,
    state: SettingsState
  ) {
    self.itemListViewModel = itemListViewModel
    self.state = state
  }
  
  public func send(_ action: SettingsAction) {}
}

final class RealSettingsViewModel: SettingsViewModel {
  
  private let getAppVersion: GetAppVersion
  
  init(
    getAppVersion: GetAppVersion,
    itemListViewModel: ItemListViewModel,
    initialState: SettingsState = .initial
  ) {
    self.getAppVersion = getAppVersion
    super.init(
      itemListViewModel: itemListViewModel,
      state: initialState
    )
    load()
  }
  
  override func send(_ action: SettingsAction) {
    switch action {
    case .none: {}()
    }
  }
  
  private func load() {
    Task {
      state.appVersion = getAppVersion.run().toGenericLce(\.string)
    }
  }
}

public final class FakeSettingsViewModel: SettingsViewModel {
  public init() {
    super.init(
      itemListViewModel: FakeItemListViewModel(),
      state: .initial
    )
  }
}
