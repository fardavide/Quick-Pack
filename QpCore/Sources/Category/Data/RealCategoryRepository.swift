import AppStorage
import CategoryDomain
import Combine
import Foundation
import QpStorage
import QpUtils
import StorageModels
import SwiftData
import TripDomain

final class RealCategoryRepository: AppStorage, CategoryRepository {
  
  let container: ModelContainer
  
  lazy var categories: any DataPublisher<[ItemCategory]> = {
    observe { context in
      context.fetchAll(
        map: { $0.toDomainModels() },
        FetchDescriptor<CategorySwiftDataModel>(
          sortBy: [SortDescriptor(\.order), SortDescriptor(\.name)]
        )
      )
    }
  }()
  
  init(container: ModelContainer) {
    self.container = container
  }
  
  @MainActor func updateCategoryName(categoryId: CategoryId, name: String) {
    update(categoryId.fetchDescriptor) { model in
      model.name = name
    }
  }
  
  @MainActor func updateCategoriesOrder(sortedCategories: [ItemCategory]) {
    transaction { context in
      for (index, category) in sortedCategories.withIndices() {
        updateInTransaction(context: context, category.id.fetchDescriptor) { model in
          model.order = index
        }
      }
    }
  }
  
  @MainActor func deleteCategory(categoryId: CategoryId) {
    delete(categoryId.fetchDescriptor)
  }
  
  func cleanUp() {}
}
