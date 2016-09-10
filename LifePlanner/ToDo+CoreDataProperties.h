//
//  ToDo+CoreDataProperties.h
//  LifePlanner
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 Daniel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *alert;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *isCompleted;
@property (nullable, nonatomic, retain) NSNumber *isFloating;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *notification;
@property (nullable, nonatomic, retain) Goal *goalForHabit;
@property (nullable, nonatomic, retain) Habit *habitForToDo;

@end

NS_ASSUME_NONNULL_END
