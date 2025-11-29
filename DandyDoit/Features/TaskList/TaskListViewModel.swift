import Foundation

class TaskListViewModel {
    private let persistenceService: PersistenceServiceProtocol
    var tasks: [Task] = [] {
        didSet {
            onTasksUpdated?()
        }
    }
    
    var onTasksUpdated: (() -> Void)?
    
    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
        loadTasks()
    }
    
    func loadTasks() {
        tasks = persistenceService.loadTasks()
    }
    
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
        persistenceService.saveTasks(tasks)
    }
    
    func deleteTasks(at indices: [Int]) {
        // Sort indices in descending order to avoid index out of bounds when removing
        let sortedIndices = indices.sorted(by: >)
        for index in sortedIndices {
            if index < tasks.count {
                tasks.remove(at: index)
            }
        }
        persistenceService.saveTasks(tasks)
    }
    
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
        persistenceService.saveTasks(tasks)
    }
}
