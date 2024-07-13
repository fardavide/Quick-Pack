import CategoryDomain
import Foundation
import Presentation

@frozen public struct CategoryListState: Equatable, Sendable {
  let categories: DataLce<[ItemCategory]>
}

public extension CategoryListState {
  static let initial = CategoryListState(categories: .loading)
  static let samples = CategoryListStateSamples()
  
  func moveCategories(from: IndexSet, to: Int) -> CategoryListState {
    CategoryListState(
      categories: categories.map {
        var array = $0
        array.move(fromOffsets: from, toOffset: to)
        return array
      }
    )
  }
  
  func removeCategory(categoryId: CategoryId) -> CategoryListState {
    CategoryListState(
      categories: categories.map { $0.filter { $0.id != categoryId } }
    )
  }
  
  func updateCategoryName(categoryId: CategoryId, newName: String) -> CategoryListState {
    CategoryListState(
      categories: categories.map {
        $0.map { category in
          if category.id != categoryId {
            category.withName(newName)
          } else {
            category
          }
        }
      }
    )
  }
}

public final class CategoryListStateSamples: Sendable {
  let content = CategoryListState(
    categories: .content(
      [
        .samples.clothes,
        .samples.misc,
        .samples.tech
      ]
    )
  )
  let empty = CategoryListState(categories: .content([]))
}
