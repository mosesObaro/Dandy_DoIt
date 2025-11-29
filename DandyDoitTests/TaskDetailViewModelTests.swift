import XCTest
@testable import DandyDoit

class TaskDetailViewModelTests: XCTestCase {
    var mockPersistenceService: MockPersistenceService!
    
    override func setUp() {
        super.setUp()
        mockPersistenceService = MockPersistenceService()
    }
    
    func testSaveNewTask() {
        let viewModel = TaskDetailViewModel(persistenceService: mockPersistenceService)
        viewModel.title = "New Task"
        viewModel.saveTask()
        
        XCTAssertEqual(mockPersistenceService.tasks.count, 1)
        XCTAssertEqual(mockPersistenceService.tasks.first?.title, "New Task")
    }
    
    func testUpdateExistingTask() {
        let task = Task(title: "Old Title")
        mockPersistenceService.tasks = [task]
        
        let viewModel = TaskDetailViewModel(task: task, persistenceService: mockPersistenceService)
        viewModel.title = "New Title"
        viewModel.saveTask()
        
        XCTAssertEqual(mockPersistenceService.tasks.count, 1)
        XCTAssertEqual(mockPersistenceService.tasks.first?.title, "New Title")
        XCTAssertEqual(mockPersistenceService.tasks.first?.id, task.id)
    }
    
    func testSaveEmptyTitle() {
        let viewModel = TaskDetailViewModel(persistenceService: mockPersistenceService)
        viewModel.title = ""
        viewModel.saveTask()
        
        XCTAssertEqual(mockPersistenceService.tasks.count, 0)
    }
}
