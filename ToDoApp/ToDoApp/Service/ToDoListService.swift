//
//  ToDoListService.swift
//  ToDoApp
//
//  Created by Sawy on 05.12.23.
//

import ToDoShared

protocol ToDoListServiceType {
    func getTaskList() -> [ToDoItem]
    func addTask(withtitle title: String)
    func editTask(withId id: String, newTitle title: String)
    func addSubTask(toTaskId id: String, subtaskTitle: String)
    func setTaskCompleted(for taskId: String, completed: Bool)
    func deleteTask(with taskId: String)
    func deleteSubtask(with taskId: String)
}

class ToDoListService: ToDoListServiceType {
    // MARK: Properties
    private lazy var toDoList = ToDoList()
    
    // MARK: Function
    func getTaskList() -> [ToDoItem] {
        guard let tasks = toDoList.getTasks() as? [ToDoItem] else { return [] }
        
        return tasks
    }
    
    func addTask(withtitle title: String) {
        toDoList.addTask(withTitle: title)
    }
    
    func editTask(withId id: String, newTitle title: String) {
        toDoList.editTask(withId: id, newTitle: title)
    }
    
    func addSubTask(toTaskId id: String, subtaskTitle: String) {
        toDoList.addSubtask(toTaskId: id, subtaskTitle: subtaskTitle)
    }
    
    func setTaskCompleted(for taskId: String, completed: Bool) {
        toDoList.setTaskAndChildrenCompleted(taskId, completed: completed)
    }
    
    func deleteTask(with taskId: String) {
        toDoList.deleteTask(withId: taskId)
    }
    
    func deleteSubtask(with taskId: String) {
        toDoList.deleteSubtask(withId: taskId)
    }
}
