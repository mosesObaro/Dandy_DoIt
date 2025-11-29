import Foundation

class TaskDetailViewModel {
    private let persistenceService: PersistenceServiceProtocol
    var task: Task?
    var onSave: (() -> Void)?
    
    var title: String = ""
    
    var isEditing: Bool {
        return task != nil
    }
    
    init(task: Task? = nil, persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.task = task
        self.persistenceService = persistenceService
        self.title = task?.title ?? ""
    }
    
    func saveTask() {
        guard !title.isEmpty else { return }
        
        var tasks = persistenceService.loadTasks()
        
        if let task = task {
            // Update existing
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                var updatedTask = task
                updatedTask.title = title
                tasks[index] = updatedTask
            }
        } else {
            // Create new
            let newTask = Task(title: title)
            tasks.append(newTask)
        }
        
        persistenceService.saveTasks(tasks)
        onSave?()
    }
}
