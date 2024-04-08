import QpUtils
import SFSafeSymbols
import SwiftUI

public struct SpecialCaseView: View {
  
  private let model: SpecialCaseModel
  private let action: SpecialCaseAction?
  
  init(
    _ model: SpecialCaseModel
  ) {
    self.model = model
    self.action = nil
  }
  
  init(
    _ model: SpecialCaseModel,
    actionText: LocalizedStringKey,
    action: @escaping () -> Void
  ) {
    self.model = model
    self.action = SpecialCaseAction(text: actionText, action: action)
  }
  
  public var body: some View {
    VStack {
      Image(systemSymbol: model.image)
        .font(.system(size: 80))
        .symbolEffect(.pulse)
        .foregroundStyle(model.imageColors.primary, model.imageColors.secondary)
        .padding(.all, 20)
      
      Text(model.title)
        .font(.headline)
        .padding(.all, 10)
      
      if let subtitle = model.subtitle {
        Text(subtitle)
          .font(.footnote)
      }
      
      if let action = action {
        Button(action.text, action: action.action)
          .padding()
      }
    }
    .padding()
    .multilineTextAlignment(.center)
  }
}

struct SpecialCaseAction {
  let text: LocalizedStringKey
  let action: () -> Void
}

#Preview("Zero with subtitle and action") {
  SpecialCaseView.zero(
    title: "No trips",
    subtitle: "Create your first trip",
    image: .backpack,
    actionText: "Create",
    action: {}
  )
}

#Preview("Zero without subtitle and action") {
  SpecialCaseView.zero(
    title: "Special case title",
    image: .backpack
  )
}

#Preview("Error with subtitle and retry") {
  SpecialCaseView.error(
    title: "Cannot get trips",
    subtitle: "Please contact the developer",
    image: .backpack,
    retry: {}
  )
}

#Preview("Error without subtitle and action") {
  SpecialCaseView.zero(
    title: "Special case title",
    image: .backpack
  )
}
