//
//  ToDoTableCellViewModel.swift
//  ToDoApp
//
//  Created by Sawy on 07.12.23.
//

import Combine

protocol ToDoTableCellViewModelDelegate: AnyObject {
    func updateToDoList()
}

class ToDoTableCellViewModel {
    // MARK: Properties
    @Published var title: String = ""
    @Published var buttonImageName: String = ""
    
    // MARK: Private properties
    private let task: TaskItem
    private let service: ToDoListServiceType
    private weak var delegate: ToDoTableCellViewModelDelegate?
    private var completed = false
    
    // MARK: Init
    init(task: TaskItem, service: ToDoListServiceType, delegate: ToDoTableCellViewModelDelegate) {
        self.task = task
        self.service = service
        self.delegate = delegate
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
        delegate?.updateToDoList()
    }
}

private extension ToDoTableCellViewModel {
    private func setupDoneButton() {
        buttonImageName = completed ? "checkmark.circle.fill" : "checkmark.circle"
    }
}
