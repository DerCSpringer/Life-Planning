//
//  Goal+CoreDataProperties.h
//  LifePlanner
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Goal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Goal (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSNumber *isCompleted;
@property (nullable, nonatomic, retain) NSSet<Habit *> *habitsForGoal;
@property (nullable, nonatomic, retain) NSSet<ToDo *> *toDosForGoal;

@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)addHabitsForGoalObject:(Habit *)value;
- (void)removeHabitsForGoalObject:(Habit *)value;
- (void)addHabitsForGoal:(NSSet<Habit *> *)values;
- (void)removeHabitsForGoal:(NSSet<Habit *> *)values;

- (void)addToDosForGoalObject:(ToDo *)value;
- (void)removeToDosForGoalObject:(ToDo *)value;
- (void)addToDosForGoal:(NSSet<ToDo *> *)values;
- (void)removeToDosForGoal:(NSSet<ToDo *> *)values;

@end

NS_ASSUME_NONNULL_END
