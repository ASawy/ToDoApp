//
//  ToDoListTests.swift
//  ToDoSharedTests
//
//  Created by Sawy on 28.11.23.
//

import XCTest
@testable import ToDoApp

class ToDoListTests: XCTestCase {
    var toDoList: ToDoList!
    
    override func setUp() {
        super.setUp()
        // Initialize a new ToDoList before each test
        toDoList = ToDoList()
    }
    
    func testAddTaskWithTitle() {
        toDoList.addTask(withTitle: "Task 1")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.title, "Task 1")
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testAddSubtaskToTaskWithIdSubtaskTitle() {
        toDoList.addTask(withTitle: "Task 1")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.addSubtaskToTask(withId: taskId, subtaskTitle: "Subtask 1")
            
            if let subTasks = tasks.first?.subtasks as? [ToDoItem] {
                XCTAssertEqual(subTasks.count, 1)
                XCTAssertEqual(subTasks.first?.title, "Subtask 1")
            } else {
                XCTFail("Failed to unwrap subTasks")
            }
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testEditTaskWithIdNewTitle() {
        toDoList.addTask(withTitle: "Original Title")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.editTask(withId: taskId, newTitle: "Updated Title")
            XCTAssertEqual(tasks.first?.title, "Updated Title")
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testDeleteTaskWithId() {
        toDoList.addTask(withTitle: "Task 1")
        toDoList.addTask(withTitle: "Task 2")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.deleteTask(withId: taskId)
            
            if let tasks = toDoList.getTasks() as? [ToDoItem] {
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Task 2")
            } else {
                XCTFail("Failed to unwrap tasks")
            }
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testDeleteSubtaskWithId() {
        toDoList.addTask(withTitle: "Task 1")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.addSubtaskToTask(withId: taskId, subtaskTitle: "Subtask 1")
            
            if let subTasks = tasks.first?.subtasks as? [ToDoItem] {
                let subtaskId = subTasks.first?.taskId ?? ""
                toDoList.deleteSubtask(withId: subtaskId)
                
                if let subTasks = tasks.first?.subtasks as? [ToDoItem] {
                    XCTAssertEqual(subTasks.count, 0)
                } else {
                    XCTFail("Failed to unwrap subTasks")
                }
            } else {
                XCTFail("Failed to unwrap subTasks")
            }
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testSetTaskWithIdCompleted() {
        toDoList.addTask(withTitle: "Task 1")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.addSubtaskToTask(withId: taskId, subtaskTitle: "Subtask 1")
            
            let subtaskId = (tasks.first?.subtasks as? [ToDoItem])?.first?.taskId ?? ""
            toDoList.setTaskWithId(taskId, completed: true)
            toDoList.setTaskWithId(subtaskId, completed: true)
            
            XCTAssertTrue(tasks.first?.isTaskCompleted() ?? false)
            XCTAssertTrue(toDoList.isTaskCompleted(withId: subtaskId))
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
    
    func testMarkSubtaskAndChildrenCompleted() {
        toDoList.addTask(withTitle: "Task 1")
        
        if let tasks = toDoList.getTasks() as? [ToDoItem] {
            let taskId = tasks.first?.taskId ?? ""
            toDoList.addSubtaskToTask(withId: taskId, subtaskTitle: "Subtask 1")
            
            if let subtasks = tasks.first?.subtasks as? [ToDoItem] {
                let subtaskId = subtasks.first?.taskId ?? ""
                toDoList.addSubtaskToTask(withId: subtaskId, subtaskTitle: "Subtask 2")
                toDoList.markSubtaskAndChildrenCompleted(subtaskId, completed: true)
                
                XCTAssertTrue(tasks.first?.isTaskCompleted() ?? false)
                XCTAssertTrue(subtasks.first?.isTaskCompleted() ?? false)
                XCTAssertTrue((subtasks.first?.subtasks as? [ToDoItem])?.first?.isTaskCompleted() ?? false)
            } else {
                XCTFail("Failed to unwrap subTasks")
            }
        } else {
            XCTFail("Failed to unwrap tasks")
        }
    }
}
