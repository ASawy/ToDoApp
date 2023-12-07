//
//  TaskItem.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import Foundation

struct TaskItem {
    // MARK: Properties
    let taskId: String
    let title: String
    let completed: Bool
    
    // MARK: Computed properties
    var displayTaskId: String {
        return formateTaskId()
    }
    
    // MARK: Function
    private func formateTaskId() -> String {
        let spaceIndex = 5
        let count = taskId.components(separatedBy: ".").count
        let space = Array(repeating: " ", count: spaceIndex * (count - 1))
        
        let prefixString = count == 1 ? "Root" : "Child"
        return "\(space.joined())\(prefixString) \(taskId)"
    }
}
