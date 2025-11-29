import Foundation

protocol PersistenceServiceProtocol {
    func saveTasks(_ tasks: [Task])
    func loadTasks() -> [Task]
}

class PersistenceService: PersistenceServiceProtocol {
    private let defaults = UserDefaults.standard
    private let tasksKey = "tasks_persistence_key"
    
    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            defaults.set(data, forKey: tasksKey)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    func loadTasks() -> [Task] {
        guard let data = defaults.data(forKey: tasksKey) else { return [] }
        do {
            let tasks = try JSONDecoder().decode([Task].self, from: data)
            return tasks
        } catch {
            print("Failed to load tasks: \(error)")
            return []
        }
    }
}
