import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = TaskListViewModel()
        let vc = TaskListViewController()
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToAddTask() {
        let viewModel = TaskDetailViewModel()
        let vc = TaskDetailViewController()
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToEditTask(_ task: Task) {
        let viewModel = TaskDetailViewModel(task: task)
        let vc = TaskDetailViewController()
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
