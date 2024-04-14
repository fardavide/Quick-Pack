import ItemDomain
import SwiftUI
import TripDomain

struct TripItemList: View {
  let items: [TripItem]
  let send: (EditTripAction) -> Void
    
  public var body: some View {
    List {
      ForEach(items) { tripItem in
        let isCheckedBinding = Binding(
          get: { tripItem.isChecked },
          set: { newIsChecked in
            if newIsChecked != tripItem.isChecked {
              send(.updateItemCheck(tripItem.id, newIsChecked))
            }
          }
        )
        HStack {
          Toggle(isOn: isCheckedBinding) {
            Text(tripItem.item.name).tint(.primary)
          }
          Spacer()
          Image(systemSymbol: .line3Horizontal)
        }
        .toggleStyle(CheckboxToggleStyle())
        .swipeActions(edge: .trailing) {
          Button { send(.removeItem(tripItem.id)) } label: {
            Label("Remove item", systemSymbol: .xmark)
              .tint(.accentColor)
          }
        }
      }
      .animation(.default, value: items)
    }
  }
}

private struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button { configuration.isOn.toggle() } label: {
      HStack {
        Image(systemSymbol: configuration.isOn ? .checkmarkSquare : .square)
        configuration.label
      }
    }
  }
}

#Preview {
  TripItemList(
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    send: { _ in }
  )
}
