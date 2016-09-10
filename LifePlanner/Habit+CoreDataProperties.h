//
//  Habit+CoreDataProperties.h
//  Life Plan
//
//  Created by Daniel on 8/7/16.
//  Copyright © 2016 Daniel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Habit.h"

NS_ASSUME_NONNULL_BEGIN

@interface Habit (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *alertType;
@property (nullable, nonatomic, retain) NSNumber *completedTimes;
@property (nullable, nonatomic, retain) NSNumber *continuing;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSDate *dateHabitWasLastModified;
@property (nullable, nonatomic, retain) id dates;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *notification;
@property (nullable, nonatomic, retain) NSNumber *penality;
@property (nullable, nonatomic, retain) NSNumber *timesToComplete;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) Goal *goalForHabit;
@property (nullable, nonatomic, retain) NSSet<ToDo *> *toDosForHabit;

@end

@interface Habit (CoreDataGeneratedAccessors)

- (void)addToDosForHabitObject:(ToDo *)value;
- (void)removeToDosForHabitObject:(ToDo *)value;
- (void)addToDosForHabit:(NSSet<ToDo *> *)values;
- (void)removeToDosForHabit:(NSSet<ToDo *> *)values;

@end

NS_ASSUME_NONNULL_END
