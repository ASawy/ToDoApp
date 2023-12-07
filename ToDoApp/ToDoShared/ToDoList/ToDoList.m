//
//  ToDoList.m
//  ToDoShared
//
//  Created by Sawy on 27.11.23.
//

#import "ToDoList.h"

@interface ToDoList ()

@end

@implementation ToDoList

NSMutableArray<ToDoItem *> *tasks;

// MARK: Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        tasks = [[NSMutableArray<ToDoItem *> alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [tasks release];
    
    [super dealloc];
}

// MARK: Public functions
- (NSMutableArray<ToDoItem *> *)getTasks {
    return tasks;
}

- (void)addTaskWithTitle:(NSString *)title {
    ToDoItem *newTask = [[ToDoItem alloc] init];
    [newTask createTaskWithTitle:title];
    [tasks addObject:newTask];
}

- (void)addSubtaskToTaskWithId:(NSString *)taskId subtaskTitle:(NSString *)subtaskTitle {
    ToDoItem *parentTask = [self findTaskWithId:taskId];
    ToDoItem *newSubtask = [[ToDoItem alloc] init];
    [newSubtask createSubtaskWithTitle:subtaskTitle parentTaskId:parentTask.taskId];
    [parentTask.subtasks addObject:newSubtask];
}

- (void)editTaskWithId:(NSString *)taskId newTitle:(NSString *)newTitle {
    ToDoItem *taskToEdit = [self findTaskWithId:taskId];
    [taskToEdit editTaskWithTitle:newTitle];
}

- (void)deleteTaskWithId:(NSString *)taskId {
    ToDoItem *taskToDelete = [self findTaskWithId:taskId];
    [tasks removeObject:taskToDelete];
}

- (void)deleteSubtaskWithId:(NSString *)subtaskId {
    ToDoItem *subtaskToDelete = [self findTaskWithId:subtaskId];
    ToDoItem *parentTask = [self findTaskWithId:[subtaskId componentsSeparatedByString:@"."].firstObject];
    [parentTask.subtasks removeObject:subtaskToDelete];
}

- (void)setTaskWithId:(NSString *)taskId completed:(BOOL)completed {
    ToDoItem *task = [self findTaskWithId:taskId];
    [task setTaskCompleted:completed];

    // If it's a subtask, update parent task completion status
    if ([taskId containsString:@"."]) {
        ToDoItem *parentTask = [self findTaskWithId:[taskId componentsSeparatedByString:@"."].firstObject];
        [self updateParentTaskCompletionStatus:parentTask];
    }
}

- (BOOL)isTaskCompletedWithId:(NSString *)taskId {
    ToDoItem *task = [self findTaskWithId:taskId];
    return [task isTaskCompleted];
}

- (void)markSubtaskAndChildrenCompleted:(NSString *)subtaskId completed:(BOOL)completed {
    ToDoItem *subtask = [self findTaskWithId:subtaskId];
    [subtask markSubtaskAndChildrenCompleted:completed];

    // Update parent task completion status
    ToDoItem *parentTask = [self findTaskWithId:[subtaskId componentsSeparatedByString:@"."].firstObject];
    [self updateParentTaskCompletionStatus:parentTask];
}

// MARK: Private functions
- (ToDoItem *)findTaskWithId:(NSString *)taskId {
    for (ToDoItem *task in tasks) {
        if ([task.taskId isEqualToString:taskId]) {
            return task;
        }
        
        ToDoItem *foundTask = [task findSubtaskWithId:taskId];
        if (foundTask) {
            return foundTask;
        }
    }
    return nil;
}

- (void)updateParentTaskCompletionStatus:(ToDoItem *)parentTask {
    BOOL allSubtasksCompleted = YES;
    for (ToDoItem *subtask in parentTask.subtasks) {
        if (!subtask.completed) {
            allSubtasksCompleted = NO;
            break;
        }
    }
    [parentTask setTaskCompleted:allSubtasksCompleted];
}

@end
