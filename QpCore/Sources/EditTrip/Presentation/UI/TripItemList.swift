import ItemDomain
import SwiftUI
import TripDomain

struct TripItemList: View {
  let items: [EditableTripItem]
  let send: (EditTripAction) -> Void
    
  public var body: some View {
    List {
      ForEach(items) { item in
        let isCheckedBinding = Binding(
          get: { item.isChecked },
          set: { newIsChecked in
            if newIsChecked != item.isChecked {
              send(.updateItemCheck(item.id, newIsChecked))
            }
          }
        )
        HStack {
          Toggle(isOn: isCheckedBinding) {
            Text(item.name).tint(.primary)
          }
          Spacer()
          Image(systemSymbol: .line3Horizontal)
        }
        .toggleStyle(CheckboxToggleStyle())
        .swipeActions(edge: .trailing) {
          Button { send(.removeItem(item.id)) } label: {
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
