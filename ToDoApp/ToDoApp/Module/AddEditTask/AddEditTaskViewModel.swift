//
//  AddEditTaskViewModel.swift
//  ToDoApp
//
//  Created by Sawy on 06.12.23.
//

import Combine

class AddEditTaskViewModel {
    // MARK: Properties
    @Published var title: String = ""
    @Published var isButtonEnabled: Bool = false
    
    // MARK: private Properties
    private let service: ToDoListServiceType
    private let task: TaskItem?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Init
    init(service: ToDoListServiceType, task: TaskItem? = nil) {
        self.service = service
        self.task = task
        self.title = task?.title ?? ""
        bind()
        
        
    }
    
    // MARK: User actions
    func saveButtonTapped() {
        if task == nil {
            // Add new task
            service.addTask(withtitle: title)
        } else {
            // Edit task
            guard let task = self.task else { return }
            service.editTask(withId: task.taskId, newTitle: title)
        }
        
        title = "" // reset the title 
    }
}

private extension AddEditTaskViewModel {
    func bind() {
        $title
            .map { !$0.isEmpty && $0 != self.task?.title}
            .assign(to: \.isButtonEnabled, on: self)
            .store(in: &cancellables)
    }
}
