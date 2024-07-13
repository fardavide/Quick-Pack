import AboutDomain
import Combine
import Presentation

@frozen public struct SettingsState {
  let appVersion: GenericLce<String>
  
  public init(appVersion: GenericLce<String>) {
    self.appVersion = appVersion
  }
}

public extension SettingsState {
  static let initial = SettingsState(appVersion: .loading)
  static let samples = SettingsStateSamples()
}

public final class SettingsStateSamples: Sendable {
  let content = SettingsState(appVersion: .content(AppVersion.sample.string))
  let error = SettingsState(appVersion: .error)
}
