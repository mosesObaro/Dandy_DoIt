import UIKit

class TaskListViewController: UIViewController {
    var viewModel: TaskListViewModel!
    weak var coordinator: AppCoordinator?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do List"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavigationBar()
        
        viewModel.onTasksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadTasks()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem = editButtonItem
        
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didTapBulkDelete))
        deleteButton.tintColor = .systemRed
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, deleteButton]
    }
    
    @objc private func didTapBulkDelete() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        
        let indices = selectedIndexPaths.map { $0.row }
        viewModel.deleteTasks(at: indices)
        
        // Exit edit mode
        setEditing(false, animated: true)
    }
    
    @objc private func didTapAdd() {
        coordinator?.goToAddTask()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        navigationController?.setToolbarHidden(!editing, animated: animated)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            // Handle selection for bulk delete if needed
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks[indexPath.row]
        coordinator?.goToEditTask(task)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath.row)
        }
    }
}
