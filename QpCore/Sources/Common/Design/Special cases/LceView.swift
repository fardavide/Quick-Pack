import Presentation
import QpUtils
import SFSafeSymbols
import SwiftUI

public struct LceView<Content: Equatable>: View {
  
  private let content: (Content) -> AnyView
  private let errorMessage: LocalizedStringKey?
  private let lce: DataLce<Content>
  private let retry: (() -> Void)?
  
  public init(
    lce: DataLce<Content>,
    errorMessage: LocalizedStringKey? = nil,
    content: @escaping (Content) -> any View,
    retry: (() -> Void)? = nil
  ) {
    self.content = { data in AnyView(content(data)) }
    self.errorMessage = errorMessage
    self.lce = lce
    self.retry = retry
  }
  
  public var body: some View {
    switch lce {
    case let .content(data): 
      content(data)
    case let .error(dataError):
      SpecialCaseView.error(dataError, message: errorMessage, retry: retry)
    case .loading:
      Text("Loading placeholder")
    }
  }
}

#Preview("Content") {
  let lce = DataLce.content("Hello world")
  return LceView(
    lce: lce,
    content: { text in Text(text) },
    retry: {}
  )
}

#Preview("Loading") {
  let lce: DataLce<String> = DataLce.loading
  return LceView(
    lce: lce,
    content: { text in Text(text) },
    retry: {}
  )
}

#Preview("Error") {
  let lce: DataLce<String> = DataLce.error(.noData)
  return LceView(
    lce: lce,
    errorMessage: "Cannot load trips",
    content: { text in Text(text) },
    retry: {}
  )
}
