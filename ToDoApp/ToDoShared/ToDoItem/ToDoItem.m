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

NSString* rootTaskIdUserDefaultsKey = @"rootTaskIdUserDefaultsKey";
NSString* taskIdCountersUserDefaultsKey = @"taskIdCountersUserDefaultsKey";

static NSUInteger rootTaskIdCounter;
static NSMutableDictionary<NSString *, NSNumber *> *taskIdCounters;

// MARK: Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _taskId = @"";
        _title = @"";
        _completed = NO;
        _subtasks = [[NSMutableArray<ToDoItem *> alloc] init];
        
        rootTaskIdCounter = [self loadRootTaskIdFromUserDefaults];
        taskIdCounters = [self loadTaskIdCountersFromUserDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _taskId = [coder decodeObjectForKey:@"TaskId"];
        _title = [coder decodeObjectForKey:@"Title"];
        _completed = [coder decodeBoolForKey:@"Completed"];
        NSMutableArray<ToDoItem *> *subTasksArray = [coder decodeObjectForKey:@"Subtasks"];
        _subtasks = [[NSMutableArray<ToDoItem *> alloc] initWithArray:subTasksArray];
        
        NSMutableDictionary<NSString *, NSNumber *> *taskIdCountersDictionary = [coder decodeObjectForKey:@"TaskIdCounters"];
        taskIdCounters = [[NSMutableDictionary<NSString *, NSNumber *> alloc] initWithDictionary:taskIdCountersDictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_taskId forKey:@"TaskId"];
    [coder encodeObject:_title forKey:@"Title"];
    [coder encodeBool:_completed forKey:@"Completed"];
    [coder encodeObject:_subtasks forKey:@"Subtasks"];
    
    [coder encodeObject:taskIdCounters forKey:@"TaskIdCounters"];
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
    if (!rootTaskIdCounter) {
        rootTaskIdCounter = 1;
    }
    
    self.title = title;
    self.taskId = [NSString stringWithFormat:@"%lu", (unsigned long)(rootTaskIdCounter++)];
    [self saveRootTaskIdToUserDefaults];
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
    [self saveTaskIdCountersToUserDefaults];
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

// MARK: Private function - User defaults
- (void)saveRootTaskIdToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(rootTaskIdCounter) forKey:rootTaskIdUserDefaultsKey];
    [defaults synchronize];
}

- (NSUInteger)loadRootTaskIdFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:rootTaskIdUserDefaultsKey];
}

- (void)saveTaskIdCountersToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTaskIdCounters = [NSKeyedArchiver archivedDataWithRootObject:taskIdCounters];
    [defaults setObject:encodedTaskIdCounters forKey:taskIdCountersUserDefaultsKey];
    [defaults synchronize];
}

- (NSMutableDictionary<NSString *, NSNumber *> *)loadTaskIdCountersFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedTaskIdCounters = [defaults objectForKey:taskIdCountersUserDefaultsKey];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedTaskIdCounters];
}

@end
