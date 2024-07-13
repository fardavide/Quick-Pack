import AboutDomain
import CategoryListPresentation
import ItemListPresentation
import Presentation
import SwiftUI

public class SettingsViewModel: ViewModel {
  public typealias Action = SettingsAction
  public typealias State = SettingsState
  
  @Published public var state: State
  public let categoryListViewModel: CategoryListViewModel
  public let itemListViewModel: ItemListViewModel
  
  init(
    categoryListViewModel: CategoryListViewModel,
    itemListViewModel: ItemListViewModel,
    state: SettingsState
  ) {
    self.categoryListViewModel = categoryListViewModel
    self.itemListViewModel = itemListViewModel
    self.state = state
  }
  
  public func send(_ action: SettingsAction) {}
}

final class RealSettingsViewModel: SettingsViewModel {
  
  private let getAppVersion: GetAppVersion
  
  init(
    categoryListViewModel: CategoryListViewModel,
    getAppVersion: GetAppVersion,
    itemListViewModel: ItemListViewModel,
    initialState: SettingsState = .initial
  ) {
    self.getAppVersion = getAppVersion
    super.init(
      categoryListViewModel: categoryListViewModel,
      itemListViewModel: itemListViewModel,
      state: initialState
    )
    state = SettingsState(appVersion: getAppVersion.run().toGenericLce(\.string))
  }
  
  override func send(_ action: SettingsAction) {
    switch action {
    case .none: {}()
    }
  }
}

public final class FakeSettingsViewModel: SettingsViewModel {
  public init() {
    super.init(
      categoryListViewModel: FakeCategoryListViewModel(),
      itemListViewModel: FakeItemListViewModel(),
      state: .initial
    )
  }
}
