import QpUtils
import SFSafeSymbols
import SwiftUI

public extension SpecialCaseView {
  
  static func error(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol = .exclamationmarkCircle,
    retry: (() -> Void)? = nil
  ) -> SpecialCaseView {
    let model = SpecialCaseModel(
      title: title,
      subtitle: subtitle,
      image: image,
      imageColors: .error
    )
    return if let retry = retry {
      SpecialCaseView(
        model,
        actionText: "Retry",
        action: retry
      )
    } else {
      SpecialCaseView(model)
    }
  }
  
  static func error(
    _ dataError: DataError,
    message: LocalizedStringKey? = nil,
    retry: (() -> Void)? = nil
  ) -> SpecialCaseView {
    let baseModel = switch dataError {
    case .noData: SpecialCaseModel.error(
      title: "Data not found, please contact the developer",
      image: .exclamationmarkCircle
    )
    case .unknown: SpecialCaseModel.error(
      title: "Unknown error, please contact the developer",
      image: .exclamationmarkTriangle
    )
    }
    return if let retry = retry {
      SpecialCaseView(
        baseModel.withMessage(message: message),
        actionText: "Retry",
        action: retry
      )
    } else {
      SpecialCaseView(baseModel.withMessage(message: message))
    }
  }
  
  static func primary(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol,
    actionText: LocalizedStringKey,
    action: @escaping () -> Void
  ) -> SpecialCaseView {
    SpecialCaseView(
      SpecialCaseModel(
        title: title,
        subtitle: subtitle,
        image: image,
        imageColors: .primary
      ),
      actionText: actionText,
      action: action
    )
  }
  
  static func primary(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol
  ) -> SpecialCaseView {
    SpecialCaseView(
      SpecialCaseModel(
        title: title,
        subtitle: subtitle,
        image: image,
        imageColors: .primary
      )
    )
  }
}
