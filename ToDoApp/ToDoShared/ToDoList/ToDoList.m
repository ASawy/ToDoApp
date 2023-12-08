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

NSString* tasksUserDefaultsKey = @"tasksUserDefaultsKey";
NSMutableArray<ToDoItem *> *tasks;

// MARK: Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        tasks = [[NSMutableArray<ToDoItem *> alloc] initWithArray:[self loadTasksFromUserDefaults]];
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
    [newTask release];
    
    [self saveTasksToUserDefaults];
}

- (void)addSubtaskToTaskId:(NSString *)taskId subtaskTitle:(NSString *)subtaskTitle {
    ToDoItem *parentTask = [self findTaskWithId:taskId];
    ToDoItem *newSubtask = [[ToDoItem alloc] init];
    [newSubtask createSubtaskWithTitle:subtaskTitle parentTaskId:parentTask.taskId];
    [parentTask.subtasks addObject:newSubtask];
    [newSubtask release];
    
    [self saveTasksToUserDefaults];
}

- (void)editTaskWithId:(NSString *)taskId newTitle:(NSString *)newTitle {
    ToDoItem *taskToEdit = [self findTaskWithId:taskId];
    [taskToEdit editTaskWithTitle:newTitle];
    
    [self saveTasksToUserDefaults];
}

- (void)deleteTaskWithId:(NSString *)taskId {
    ToDoItem *taskToDelete = [self findTaskWithId:taskId];
    [tasks removeObject:taskToDelete];
    
    [self saveTasksToUserDefaults];
}

- (void)deleteSubtaskWithId:(NSString *)subtaskId {
    ToDoItem *subtaskToDelete = [self findTaskWithId:subtaskId];
    ToDoItem *parentTask = [self findTaskWithId:[self findParentTaskIdFor:subtaskId]];
    [parentTask.subtasks removeObject:subtaskToDelete];
    
    [self saveTasksToUserDefaults];
}

- (void)setTaskAndChildrenCompleted:(NSString *)taskId completed:(BOOL)completed {
    ToDoItem *task = [self findTaskWithId:taskId];
    [task markTaskAndChildrenCompleted:completed];
    
    // Update parent task completion status
    ToDoItem *parentTask = [self findTaskWithId:[self findParentTaskIdFor:taskId]];
    [self updateParentTaskCompletionStatus:parentTask];
    
    [self saveTasksToUserDefaults];
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
    
    
    ToDoItem *parent = [self findTaskWithId:[self findParentTaskIdFor:parentTask.taskId]];
    if (parent) {
        [self updateParentTaskCompletionStatus:parent];
    }
}

- (NSString *)findParentTaskIdFor:(NSString *)taskId {
    if (taskId.length == 1) {
        return @"";
    }
    
    NSRange taskIdRange = NSMakeRange(0, taskId.length - 2);
    NSString *parentTaskId = [taskId substringWithRange:taskIdRange];
    return parentTaskId;
}

- (void)saveTasksToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:tasks];
    [defaults setObject:encodedTasks forKey:tasksUserDefaultsKey];
    [defaults synchronize];
}

- (NSMutableArray<ToDoItem *> *)loadTasksFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTasks = [defaults objectForKey:tasksUserDefaultsKey];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasks];
}

@end
