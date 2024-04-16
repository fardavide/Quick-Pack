import Presentation
import QpUtils
import SFSafeSymbols
import SwiftUI

public struct LceView<Content, LceError: Error>: View where Content: Equatable, LceError: Equatable {
  
  private let content: (Content) -> AnyView
  private let errorMessage: LocalizedStringKey?
  private let error: (LceError) -> AnyView
  private let lce: Lce<Content, LceError>
  
  public var body: some View {
    switch lce {
    case let .content(data): 
      content(data)
    case let .error(lceError):
      error(lceError)
    case .loading:
      ProgressView()
    }
  }
}

public extension LceView where LceError == GenericError {
  init(
    lce: GenericLce<Content>,
    errorMessage: LocalizedStringKey,
    content: @escaping (Content) -> any View,
    retry: (() -> Void)? = nil
  ) {
    self.content = { data in AnyView(content(data)) }
    self.errorMessage = errorMessage
    self.error = { _ in
      AnyView(
        SpecialCaseView.error(
          title: errorMessage,
          retry: retry
        )
      )
    }
    self.lce = lce
  }
}

public extension LceView where LceError == DataError {
  init(
    lce: DataLce<Content>,
    errorMessage: LocalizedStringKey? = nil,
    content: @escaping (Content) -> any View,
    retry: (() -> Void)? = nil
  ) {
    self.content = { data in AnyView(content(data)) }
    self.errorMessage = errorMessage
    self.error = { dataError in
      AnyView(SpecialCaseView.error(dataError, message: errorMessage, retry: retry))
    }
    self.lce = lce
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
