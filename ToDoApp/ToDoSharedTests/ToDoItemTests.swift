//
//  ToDoItemTests.swift
//  ToDoSharedTests
//
//  Created by Sawy on 27.11.23.
//

import XCTest
@testable import ToDoShared

class ToDoItemTests: XCTestCase {
    var todoItem: ToDoItem!
    
    override func setUp() {
        super.setUp()
        // Initialize a new ToDoItem before each test
        todoItem = ToDoItem()
    }
    
    func testCreateTaskWithTitle() {
        todoItem.createTask(withTitle: "Task 1")
        XCTAssertEqual(todoItem.title, "Task 1")
        XCTAssertNotNil(todoItem.taskId)
    }
    
    func testCreateSubtaskWithTitle() {
        todoItem.createTask(withTitle: "Task 1")
        
        let subtask = ToDoItem()
        subtask.createSubtask(withTitle: "Subtask 1", parentTaskId: todoItem.taskId)
        
        XCTAssertEqual(subtask.title, "Subtask 1")
        XCTAssertNotNil(subtask.taskId)
    }
    
    func testEditTaskWithTitle() {
        todoItem.createTask(withTitle: "Original Title")
        todoItem.editTask(withTitle: "Updated Title")
        XCTAssertEqual(todoItem.title, "Updated Title")
    }
    
    func testSetTaskCompleted() {
        todoItem.createTask(withTitle: "Task 1")
        todoItem.setTaskCompleted(true)
        
        XCTAssertTrue(todoItem.isTaskCompleted())
    }
    
    func testFindSubtaskWithId() {
        todoItem.createTask(withTitle: "Task 1")
        
        let subtask = ToDoItem()
        subtask.createSubtask(withTitle: "Subtask 1", parentTaskId: todoItem.taskId)
        
        todoItem.subtasks.add(subtask)
        let subtaskId = (todoItem.subtasks as? [ToDoItem])?.first?.taskId ?? ""
        let item = todoItem.findSubtask(withId: subtaskId)
        
        XCTAssertEqual(item.title, "Subtask 1")
        XCTAssertNotNil(item.taskId)
    }
}
