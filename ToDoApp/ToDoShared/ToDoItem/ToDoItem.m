//
//  ToDoItem.m
//  ToDoShared
//
//  Created by Sawy on 27.11.23.
//

#import "ToDoItem.h"

@interface ToDoItem ()

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, strong) NSMutableArray<ToDoItem *> *subtasks;

@end

@implementation ToDoItem

static NSUInteger rootTaskIdCounter = 1;
static NSMutableDictionary<NSString *, NSNumber *> *taskIdCounters;

// MARK: Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _taskId = @"";
        _title = @"";
        _completed = NO;
        _subtasks = [[NSMutableArray<ToDoItem *> alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _taskId = [coder decodeObjectForKey:@"TaskId"];
        _title = [coder decodeObjectForKey:@"Title"];
        _completed = [coder decodeBoolForKey:@"Completed"];
        NSMutableArray<ToDoItem *> *array = [coder decodeObjectForKey:@"Subtasks"];
        _subtasks = [[NSMutableArray<ToDoItem *> alloc] initWithArray:array];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_taskId forKey:@"TaskId"];
    [coder encodeObject:_title forKey:@"Title"];
    [coder encodeBool:_completed forKey:@"Completed"];
    [coder encodeObject:_subtasks forKey:@"Subtasks"];
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
        taskIdCounters = [[NSMutableDictionary<NSString *, NSNumber *> alloc] init];
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

- (void)markTaskAndChildrenCompleted:(BOOL)completed {
    self.completed = completed;
    
    for (ToDoItem *subtask in self.subtasks) {
        [subtask markTaskAndChildrenCompleted:completed];
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
