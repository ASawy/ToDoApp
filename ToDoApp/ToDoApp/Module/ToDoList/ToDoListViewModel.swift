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
        return ToDoTableCellViewModel(task: task, service: service)
    }
    
    // MARR: User Action
    func addButtonTapped() {
        coordinator?.navigateToAddTaskView()
    }
    
    func taskDidSelect(at index: Int) {
        let task = tasks[index]
        coordinator?.navigateToEditTaskView(with: task)
    }
}

// MARK: - Private functions
private extension ToDoListViewModel {
    func mapToDoItemToTaskItem(_ toDoList: [ToDoItem]) -> [TaskItem] {
        let flatToDoList: [ToDoItem] = toDoList.flatMap { task -> [ToDoItem] in
            var flattenedTasks = [task]
            flattenedTasks += (task.subtasks as? [ToDoItem] ?? []).flatMap { subtask -> [ToDoItem] in
                // Recursively flatten subtasks
                
                return [subtask] + (subtask.subtasks as? [ToDoItem] ?? []).compactMap { $0 }
            }
            return flattenedTasks
        }
        
        return flatToDoList.map { item -> TaskItem in
            return TaskItem(taskId: item.taskId, title: item.title, completed: item.completed)
        }
    }
}
