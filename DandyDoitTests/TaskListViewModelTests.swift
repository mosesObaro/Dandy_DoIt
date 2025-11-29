import XCTest
@testable import DandyDoit

class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModel!
    var mockPersistenceService: MockPersistenceService!
    
    override func setUp() {
        super.setUp()
        mockPersistenceService = MockPersistenceService()
        viewModel = TaskListViewModel(persistenceService: mockPersistenceService)
    }
    
    func testLoadTasks() {
        let task = Task(title: "Test Task")
        mockPersistenceService.tasks = [task]
        viewModel.loadTasks()
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Test Task")
    }
    
    func testDeleteTask() {
        let task = Task(title: "Test Task")
        mockPersistenceService.tasks = [task]
        viewModel.loadTasks()
        
        viewModel.deleteTask(at: 0)
        XCTAssertEqual(viewModel.tasks.count, 0)
        XCTAssertEqual(mockPersistenceService.tasks.count, 0)
    }
    
    func testBulkDeleteTasks() {
        let task1 = Task(title: "Task 1")
        let task2 = Task(title: "Task 2")
        let task3 = Task(title: "Task 3")
        mockPersistenceService.tasks = [task1, task2, task3]
        viewModel.loadTasks()
        
        // Delete index 0 and 2
        viewModel.deleteTasks(at: [0, 2])
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Task 2")
    }
    
    func testToggleCompletion() {
        let task = Task(title: "Test Task", isCompleted: false)
        mockPersistenceService.tasks = [task]
        viewModel.loadTasks()
        
        viewModel.toggleTaskCompletion(at: 0)
        XCTAssertTrue(viewModel.tasks.first?.isCompleted ?? false)
        XCTAssertTrue(mockPersistenceService.tasks.first?.isCompleted ?? false)
    }
}
