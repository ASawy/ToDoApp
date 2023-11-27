//
//  ToDoItem.h
//  ToDoShared
//
//  Created by Sawy on 27.11.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) BOOL completed;
@property (nonatomic, strong, readonly) NSMutableArray<ToDoItem *> *subtasks;
@property (nonatomic, copy, readonly) NSString *taskId;

- (void)createTaskWithTitle:(NSString *)title;
- (void)createSubtaskWithTitle:(NSString *)title parentTaskId:(NSString *)parentTaskId;
- (void)editTaskWithTitle:(NSString *)newTitle;
- (void)setTaskCompleted:(BOOL)completed;
- (BOOL)isTaskCompleted;
- (void)markSubtaskAndChildrenCompleted:(BOOL)completed;
- (ToDoItem *)findSubtaskWithId:(NSString *)subtaskId;

@end

NS_ASSUME_NONNULL_END
