import CategoryDomain
import Design
import ItemDomain
import Presentation
import SwiftUI

struct SetCategorySheetContent: View {
  @State var currentCategory: ItemCategory?
  let allCategories: DataLce<[ItemCategory]>
  let onCategoryChange: (ItemCategory?) -> Void
  
  @State private var newCategoryName: String = ""
  
  var body: some View {
    Form {
      HStack {
        TextField("New category", text: $newCategoryName)
          .onSubmit { withAnimation { createCategory() } }
        Button("Create") { withAnimation { createCategory() } }
          .disabled(newCategoryName.isBlank)
      }
      
      Section {
        LceView(lce: allCategories) { allCategories in
          List(allCategories) { category in
            let binding = Binding(
              get: { category.id == currentCategory?.id },
              set: { isSelected in
                if isSelected {
                  changeCategory(category)
                } else if currentCategory != nil && category.id == currentCategory?.id {
                  changeCategory(nil)
                }
              }
            )
            Toggle(category.name, isOn: binding)
              .toggleStyle(CheckboxToggleStyle())
          }
        }
      }
    }
  }
  
  private func createCategory() {
    changeCategory(ItemCategory.new(name: newCategoryName))
    newCategoryName = ""
  }
  
  private func changeCategory(_ newCategory: ItemCategory?) {
    onCategoryChange(newCategory)
    currentCategory = newCategory
  }
}

private struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button { configuration.isOn.toggle() } label: {
      HStack {
        configuration.label
          .tint(.primary)
        Spacer()
        Image(systemSymbol: configuration.isOn ? .checkmarkSquareFill : .square)
          .font(.title2)
          .symbolEffect(.bounce, value: configuration.isOn)
      }
    }
  }
}

#Preview {
  SetCategorySheetContent(
    currentCategory: .samples.tech,
    allCategories: .content(
      [
        .samples.clothes,
        .samples.misc,
        .samples.tech
      ]
    ),
    onCategoryChange: { _ in }
  )
}
