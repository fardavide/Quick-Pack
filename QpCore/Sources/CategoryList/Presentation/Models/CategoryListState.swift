import CategoryDomain
import Presentation

public struct CategoryListState: Equatable {
  let categories: DataLce<[ItemCategory]>
}

public extension CategoryListState {
  static let initial = CategoryListState(categories: .loading)
  static let samples = CategoryListStateSamples()
}

public final class CategoryListStateSamples {
  let content = CategoryListState(
    categories: .content(
      [
        .samples.clothes,
        .samples.misc,
        .samples.tech
      ]
    )
  )
}
