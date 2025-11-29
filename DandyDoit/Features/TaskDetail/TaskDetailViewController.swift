import UIKit

class TaskDetailViewController: UIViewController {
    var viewModel: TaskDetailViewModel!
    weak var coordinator: AppCoordinator?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter task title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.isEditing ? "Edit Task" : "New Task"
        
        setupUI()
        setupNavigationBar()
        
        titleTextField.text = viewModel.title
    }
    
    private func setupUI() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
    }
    
    @objc private func didTapSave() {
        // Save Item
        guard let text = titleTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Title cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        viewModel.title = text
        viewModel.saveTask()
        coordinator?.navigationController.popViewController(animated: true)
    }
}
