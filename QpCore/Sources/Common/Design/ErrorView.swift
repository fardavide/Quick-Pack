import QpUtils
import SFSafeSymbols
import SwiftUI

public struct ErrorView: View {
  
  private let title: LocalizedStringKey
  private let subtitle: LocalizedStringKey?
  private let image: SFSymbol
  private let retry: (() -> Void)?
  
  public init(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol,
    retry: (() -> Void)? = nil
  ) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.retry = retry
  }
  
  public init(
    _ model: ErrorModel,
    retry: (() -> Void)? = nil
  ) {
    self.init(
      title: model.title,
      subtitle: model.subtitle,
      image: model.image,
      retry: retry
    )
  }
  
  public var body: some View {
    VStack {
      Image(systemSymbol: image)
        .font(.system(size: 80))
        .symbolEffect(.pulse)
        .foregroundStyle(.black, .red)
        .padding(.all, 20)
      
      Text(title)
        .font(.headline)
        .padding(.all, 10)
      
      if let subtitle = subtitle {
        Text(subtitle)
          .font(.footnote)
      }
      
      if let retry = retry {
        Button("Retry", action: retry)
          .padding()
      }
    }
    .padding()
    .multilineTextAlignment(.center)
  }
}

public struct ErrorModel {
  let title: LocalizedStringKey
  let subtitle: LocalizedStringKey?
  let image: SFSymbol
  
  public init(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol
  ) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
  }
  
  func withMessage(message: LocalizedStringKey?) -> ErrorModel {
    ErrorModel(
      title: message ?? title,
      subtitle: message != nil ? title : nil,
      image: image
    )
  }
}

public extension DataError {
  
  /// Creates an `ErrorModel` for `ErrorView`
  /// - Returns: `ErrorModel`
  func toErrorModel(message: LocalizedStringKey? = nil) -> ErrorModel {
    let baseModel = switch self {
    case .noData: ErrorModel(
      title: "Data not found, please contact the developer",
      image: .exclamationmarkCircle
    )
    case .unknown: ErrorModel(
      title: "Unknown error, please contact the developer",
      image: .exclamationmarkTriangle
    )
    }
    return baseModel.withMessage(message: message)
  }
}

// For preview only
private extension ErrorView {
  init(
    _ error: DataError,
    message: LocalizedStringKey? = nil,
    retry: (() -> Void)? = nil
  ) {
    self.init(
      error.toErrorModel(message: message),
      retry: retry
    )
  }
}

#Preview("No data") {
  ErrorView(.noData, message: "Can't load trips") {}
}

#Preview("Unknown") {
  ErrorView(.unknown, message: "Can't load trips") {}
}
