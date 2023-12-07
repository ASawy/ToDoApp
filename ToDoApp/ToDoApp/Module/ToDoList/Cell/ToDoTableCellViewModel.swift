//
//  ToDoTableCellViewModel.swift
//  ToDoApp
//
//  Created by Sawy on 07.12.23.
//

import Combine

class ToDoTableCellViewModel {
    // MARK: Properties
    @Published var title: String = ""
    @Published var buttonImageName: String = ""
    
    // MARK: Private properties
    private let task: TaskItem
    private let service: ToDoListServiceType
    private var completed = false
    
    // MARK: Init
    init(task: TaskItem, service: ToDoListServiceType) {
        self.task = task
        self.service = service
    }

    // MARK: Function
    func configureCell() {
        title = "\(task.displayTaskId) - \(task.title)"
        self.completed = task.completed
        
        setupDoneButton()
    }
    
    // MARK: User action
    func doneButtonTapped() {
        completed.toggle()
        setupDoneButton()
        
        service.setTaskCompleted(for: task.taskId, completed: completed)
    }
}

private extension ToDoTableCellViewModel {
    private func setupDoneButton() {
        buttonImageName = completed ? "checkmark.circle.fill" : "checkmark.circle"
    }
}
