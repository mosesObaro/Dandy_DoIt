import Foundation
@testable import DandyDoit

class MockPersistenceService: PersistenceServiceProtocol {
    var tasks: [Task] = []
    
    func saveTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }
    
    func loadTasks() -> [Task] {
        return tasks
    }
}
