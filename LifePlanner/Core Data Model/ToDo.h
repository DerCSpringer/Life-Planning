//
//  ToDo.h
//  LifePlanner
//
//  Created by Daniel on 5/18/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goal, Habit;

NS_ASSUME_NONNULL_BEGIN

@interface ToDo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//alert: alert date/time for a todo
//date: date that a todo is due
//detail: notes for todo
//isCompleted;
//isFloating;
//name;
//NSData notification: localNotification stored in nsdata format
// Goal *goalForHabit: not used
// Habit *habitForToDo: not used

@end

NS_ASSUME_NONNULL_END

#import "ToDo+CoreDataProperties.h"
