import SFSafeSymbols
import SwiftUI

public struct SpecialCaseModel {
  let title: LocalizedStringKey
  let subtitle: LocalizedStringKey?
  let image: SFSymbol
  let imageColors: ImageColors
  
  func withMessage(message: LocalizedStringKey?) -> SpecialCaseModel {
    SpecialCaseModel(
      title: message ?? title,
      subtitle: message != nil ? title : nil,
      image: image,
      imageColors: imageColors
    )
  }
  
  public struct ImageColors {
    let primary: Color
    let secondary: Color
  }
}

public extension SpecialCaseModel.ImageColors {
  
  static var primary: SpecialCaseModel.ImageColors {
    SpecialCaseModel.ImageColors(
      primary: .primary,
      secondary: .primary
    )
  }
  
  static var error: SpecialCaseModel.ImageColors {
    SpecialCaseModel.ImageColors(
      primary: .primary,
      secondary: .red
    )
  }
}

public extension SpecialCaseModel {
  
  static func primary(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol
  ) -> SpecialCaseModel {
    SpecialCaseModel(
      title: title,
      subtitle: subtitle,
      image: image,
      imageColors: .primary
    )
  }
  
  static func error(
    title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    image: SFSymbol
  ) -> SpecialCaseModel {
    SpecialCaseModel(
      title: title,
      subtitle: subtitle,
      image: image,
      imageColors: .error
    )
  }
}
