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
    func setTaskCompleted(for taskId: String, completed: Bool)
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
    
    func setTaskCompleted(for taskId: String, completed: Bool) {
        toDoList.setTaskWithId(taskId, completed: completed)
    }
}
