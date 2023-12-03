//
//  ToDoList.h
//  ToDoShared
//
//  Created by Sawy on 27.11.23.
//

#import <Foundation/Foundation.h>
#import <ToDoShared/ToDoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoList : NSObject

- (NSMutableArray<ToDoItem *> *)getTasks;
- (void)addTaskWithTitle:(NSString *)title;
- (void)addSubtaskToTaskWithId:(NSString *)taskId subtaskTitle:(NSString *)subtaskTitle;
- (void)editTaskWithId:(NSString *)taskId newTitle:(NSString *)newTitle;
- (void)deleteTaskWithId:(NSString *)taskId;
- (void)deleteSubtaskWithId:(NSString *)subtaskId;
- (void)setTaskWithId:(NSString *)taskId completed:(BOOL)completed;
- (BOOL)isTaskCompletedWithId:(NSString *)taskId;
- (void)markSubtaskAndChildrenCompleted:(NSString *)subtaskId completed:(BOOL)completed;

@end

NS_ASSUME_NONNULL_END
