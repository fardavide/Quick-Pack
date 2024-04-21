import Design
import ItemDomain
import Presentation
import SwiftUI

struct SetCategorySheetContent: View {
  let currentCategory: ItemCategory?
  let allCategories: DataLce<[ItemCategory]>
  let onCategoryChange: (ItemCategory?) -> Void
  
  @State private var newCategoryName: String = ""
  
  var body: some View {
    Form {
      TextField("New category", text: $newCategoryName)
        .onSubmit {
          onCategoryChange(.new(name: newCategoryName))
          newCategoryName = ""
        }
      
      Section {
        LceView(lce: allCategories) { allCategories in
          List(allCategories) { category in
            let binding = Binding(
              get: { category.id == currentCategory?.id },
              set: { isSelected in
                if isSelected {
                  onCategoryChange(category)
                } else if currentCategory != nil && category.id == currentCategory?.id {
                  onCategoryChange(nil)
                }
              }
            )
            Toggle(category.name, isOn: binding)
          }
        }
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
