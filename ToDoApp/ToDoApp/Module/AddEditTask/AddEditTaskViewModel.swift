//
//  AddEditTaskViewModel.swift
//  ToDoApp
//
//  Created by Sawy on 06.12.23.
//

import Combine

enum TaskState {
    case add
    case addSubtask
    case edit
}

class AddEditTaskViewModel {
    // MARK: Properties
    @Published var title: String = ""
    @Published var isButtonEnabled: Bool = false
    
    // MARK: private Properties
    private let service: ToDoListServiceType
    private let task: TaskItem?
    private let taskState: TaskState
    private var oldTitle = ""
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Init
    init(service: ToDoListServiceType, task: TaskItem? = nil, taskState: TaskState) {
        self.service = service
        self.task = task
        self.taskState = taskState
        
        self.oldTitle = taskState == .edit ? task?.title ?? "" : ""
        self.title = oldTitle
        bind()
    }
    
    // MARK: User actions
    func saveButtonTapped() {
        if taskState == .add {
            // Add new task
            service.addTask(withtitle: title)
            
        } else if taskState == .addSubtask {
            // Add subtask
            guard let task = self.task else { return }
            service.addSubTask(toTaskId: task.taskId, subtaskTitle: title)
            
        } else if taskState == .edit {
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
            .map { !$0.isEmpty && $0 != self.oldTitle}
            .assign(to: \.isButtonEnabled, on: self)
            .store(in: &cancellables)
    }
}
