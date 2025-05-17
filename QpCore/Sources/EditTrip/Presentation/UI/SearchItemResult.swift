import ItemDomain
import SwiftUI

struct SearchItemResult: View {
  let items: [Item]
  let showTimesUsed: Bool
  let send: (EditTripAction) -> Void
  
  @State var isEditingItem: Bool = false
  @State private var newName = ""
  
  var body: some View {
    ForEach(items) { item in
      HStack {
        VStack(alignment: .leading) {
          Text(item.name)
          if showTimesUsed {
            Text("Used \(item.timesUsed) times")
              .font(.footnote)
          }
        }
        Spacer()
        Text("Add item")
          .font(.caption2)
          .foregroundStyle(TintShapeStyle())
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(TintShapeStyle().opacity(0.1), in: .rect(cornerRadius: 10))
      }
      .contentShape(Rectangle())
      .onTapGesture { send(.addItem(item)) }
      .contextMenu {
        Button {
          isEditingItem = true
          newName = item.name
        } label: {
          Label("Rename", systemSymbol: .pencil)
            .tint(.accentColor)
        }
        Button { send(.deleteItem(item.id)) } label: {
          Label("Delete", systemSymbol: .trash)
            .tint(.red)
        }
      }
      .alert("Rename \(item.name)", isPresented: $isEditingItem) {
        TextField("New name", text: $newName)
        Button("OK") {
          send(.updateItemName(item.id, newName))
        }
      }
    }
    .animation(.default, value: items)
  }
}

#Preview {
  List {
    SearchItemResult(
      items: [
        .samples.camera,
        .samples.iPad,
        .samples.nintendoSwitch
      ],
      showTimesUsed: true,
      send: { _ in }
    )
  }
}
