//
//  ApplicationCoordinator.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import UIKit

protocol ToDoListCoordinatorDelegate: AnyObject {
    func navigateToAddTaskView()
    func navigateToEditTaskView(with taskItem: TaskItem)
}

class ApplicationCoordinator {
    // MARK: Properties
    private(set) var window: UIWindow?
    private lazy var service = ToDoListService()
    
    private lazy var rootNavigationController: UINavigationController = {
        let viewModel = ToDoListViewModel(service: service, coordinator: self)
        let viewController = ToDoListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()

    // MARK: Functions
    func start(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}

extension ApplicationCoordinator: ToDoListCoordinatorDelegate {
    func navigateToAddTaskView() {
        let viewModel = AddEditTaskViewModel(service: service)
        let viewController = AddEditTaskViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToEditTaskView(with taskItem: TaskItem) {
        let viewModel = AddEditTaskViewModel(service: service, task: taskItem)
        let viewController = AddEditTaskViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}
