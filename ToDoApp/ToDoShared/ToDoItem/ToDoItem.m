//
//  ToDoItem.m
//  ToDoShared
//
//  Created by Sawy on 27.11.23.
//

#import "ToDoItem.h"

@interface ToDoItem ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, strong) NSMutableArray<ToDoItem *> *subtasks;
@property (nonatomic, copy) NSString *taskId;

@end

@implementation ToDoItem

static NSUInteger rootTaskIdCounter = 1;
static NSMutableDictionary<NSString *, NSNumber *> *taskIdCounters = nil;

// MARK: Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"";
        _completed = NO;
        _subtasks = [[NSMutableArray<ToDoItem *> alloc] init];
        _taskId = @"";
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_subtasks release];
    [_taskId release];
    
    [super dealloc];
}

// MARK: Public functions
- (void)createTaskWithTitle:(NSString *)title {
    self.title = title;
    self.taskId = [NSString stringWithFormat:@"%lu", (unsigned long)(rootTaskIdCounter++)];
}

- (void)createSubtaskWithTitle:(NSString *)title parentTaskId:(NSString *)parentTaskId {
    if (!taskIdCounters) {
        taskIdCounters = [NSMutableDictionary dictionary];
    }
    
    NSNumber *counter = taskIdCounters[parentTaskId];
    if (counter == nil) {
        counter = @1;
    }
    
    self.title = title;
    self.taskId = [NSString stringWithFormat:@"%@.%lu", parentTaskId ?: @"", [counter unsignedLongValue]];
    
    taskIdCounters[parentTaskId] = @(counter.unsignedIntegerValue + 1);
}

- (void)editTaskWithTitle:(NSString *)newTitle {
    self.title = newTitle;
}

- (void)setTaskCompleted:(BOOL)completed {
    self.completed = completed;
}

- (BOOL)isTaskCompleted {
    return self.completed;
}

- (void)markSubtaskAndChildrenCompleted:(BOOL)completed {
    self.completed = completed;
    
    for (ToDoItem *subtask in self.subtasks) {
        [subtask markSubtaskAndChildrenCompleted:completed];
    }
}

- (ToDoItem *)findSubtaskWithId:(NSString *)subtaskId {
    for (ToDoItem *subtask in self.subtasks) {
        if ([subtask.taskId isEqualToString:subtaskId]) {
            return subtask;
        }
        ToDoItem *foundSubtask = [subtask findSubtaskWithId:subtaskId];
        if (foundSubtask) {
            return foundSubtask;
        }
    }
    return nil;
}

@end
