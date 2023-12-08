//
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import Combine
import ToDoShared

class ToDoListViewModel {
    // MARK: Properties
    @Published var tasks: [TaskItem] = []
    
    // MARK: private Properties
    private let service: ToDoListServiceType
    private weak var coordinator: ToDoListCoordinatorDelegate?
    
    // MARK: Init
    init(service: ToDoListServiceType, coordinator: ToDoListCoordinatorDelegate) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: Function
    func loadToDoList() {
        tasks = mapToDoItemToTaskItem(service.getTaskList())
    }
    
    // MARK: Factory Functions
    func createToDoTableCellViewModel(with  index: Int) -> ToDoTableCellViewModel {
        let task = tasks[index]
        return ToDoTableCellViewModel(task: task, service: service, delegate: self)
    }
    
    // MARR: User Action
    func addButtonTapped() {
        coordinator?.navigateToAddTaskView()
    }
    
    func taskDidSelect(at index: Int) {
        let task = tasks[index]
        coordinator?.navigateToEditTaskView(with: task)
    }
    
    func deleteButtonTapped(at index: Int) {
        let task = tasks[index]
        
        if task.taskId.components(separatedBy: ".").count == 1 {
            // delete root task
            service.deleteTask(with: task.taskId)
        } else {
            // delete subtask
            service.deleteSubtask(with: task.taskId)
        }
        
        loadToDoList()
    }
    
    func addSubTaskButtonTapped(at index: Int) {
        let task = tasks[index]
        coordinator?.navigateToAddSubtaskView(with: task)
    }
}

// MARK: - Private functions
private extension ToDoListViewModel {
    func mapToDoItemToTaskItem(_ toDoList: [ToDoItem]) -> [TaskItem] {
        let flatToDoList = flattenTasks(toDoList)
        
        return flatToDoList.map { item -> TaskItem in
            return TaskItem(taskId: item.taskId, title: item.title, completed: item.completed)
        }
    }
    
    func flattenTasks(_ tasks: [ToDoItem]) -> [ToDoItem] {
        var flattenedTasks: [ToDoItem] = []

        for task in tasks {
            flattenedTasks.append(task)
            if let subtasks = task.subtasks as? [ToDoItem] {
                flattenedTasks += flattenTasks(subtasks)
            }
        }

        return flattenedTasks
    }
}

// MARK: - ToDoTableCellViewModelDelegate
extension ToDoListViewModel: ToDoTableCellViewModelDelegate {
    func updateToDoList() {
        loadToDoList()
    }
}
