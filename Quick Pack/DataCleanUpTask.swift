import BackgroundTasks
import CategoryDomain
import Foundation
import ItemDomain
import TripDomain

final class DataCleanUpTask {
  
  private let dataCleanUpTaskId = "QP.data.cleanup"
  private let operationQueue = OperationQueue()
  private let operation: DataCleanUpOperation
  
  init(operation: DataCleanUpOperation) {
    self.operation = operation
    operationQueue.maxConcurrentOperationCount = 1
  }

  func runAndSchedule() {
    register()
    schedule()
    performCleanup()
  }
  
  private func register() {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: dataCleanUpTaskId, using: nil) { task in
      self.performCleanup(task: task as? BGAppRefreshTask)
    }
  }
  
  private func schedule() {
    let laterRequest = BGAppRefreshTaskRequest(identifier: dataCleanUpTaskId)
    laterRequest.earliestBeginDate = midnight()
    
    do {
      try BGTaskScheduler.shared.submit(laterRequest)
      print("Scheduled next cleanup for midnight")
    } catch {
      print("Could not schedule app refresh: \(error)")
    }
  }
  
  private func performCleanup(task: BGAppRefreshTask? = nil) {
    if let task = task {
      task.expirationHandler = {
        self.operationQueue.cancelAllOperations()
      }
      
//      operation.completionBlock = {
//        task.setTaskCompleted(success: !self.operation.isCancelled)
//      }
    } else {
      operation.completionBlock = {
        print("Immediate cleanup completed")
      }
    }
    
    operationQueue.addOperation(operation)
  }
  
  private func midnight() -> Date {
    let calendar = Calendar.current
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date.now)!
    return calendar.startOfDay(for: tomorrow)
  }
}

final class DataCleanUpOperation: Operation, @unchecked Sendable {

  private let categoryReposiory: CategoryRepository
  private let itemRepository: ItemRepository
  private let tripRepository: TripRepository
  
  init(
    categoryReposiory: CategoryRepository,
    itemRepository: ItemRepository,
    tripRepository: TripRepository
  ) {
    self.categoryReposiory = categoryReposiory
    self.itemRepository = itemRepository
    self.tripRepository = tripRepository
  }
  
  override func main() {
    guard !isCancelled else { return }
    Task {
      categoryReposiory.cleanUp()
      await itemRepository.cleanUp()
      await tripRepository.cleanUp()
    }
  }
}
