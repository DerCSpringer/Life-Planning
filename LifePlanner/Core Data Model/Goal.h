//
//  Goal.h
//  LifePlanner
//
//  Created by Daniel on 4/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ToDo.h"


@class Habit;

NS_ASSUME_NONNULL_BEGIN

@interface Goal : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//date: date when goal will be completed
//detail: notes
//@property (nullable, nonatomic, retain) NSString *name;
//@property (nullable, nonatomic, retain) NSDate *startDate;
//@property (nullable, nonatomic, retain) NSNumber *isCompleted;
//NSSet<Habit *> *habitsForGoal: displays the habits associated with a goal in the goal's detail table
//@property (nullable, nonatomic, retain) NSSet<ToDo *> *toDosForGoal;
@end

NS_ASSUME_NONNULL_END

#import "Goal+CoreDataProperties.h"
