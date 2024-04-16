import AboutDomain
import Combine
import Presentation

public final class SettingsState: ObservableObject {
  @Published var appVersion: GenericLce<String>
  
  public init(appVersion: GenericLce<String>) {
    self.appVersion = appVersion
  }
}

public extension SettingsState {
  static let initial = SettingsState(appVersion: .loading)
  static let samples = SettingsStateSamples()
}

public final class SettingsStateSamples {
  let content = SettingsState(appVersion: .content(AppVersion.sample.string))
  let error = SettingsState(appVersion: .error)
}
