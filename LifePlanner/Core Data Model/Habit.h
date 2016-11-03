//
//  Habit.h
//  LifePlanner
//
//  Created by Daniel on 4/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//


//id dates is a dictionary of completed dates for a habit

//id notification is the nslocalnotification used if habits are alerted(red or yellow) because of the option selected
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ToDo.h"
@class Goal;

NS_ASSUME_NONNULL_BEGIN

@interface Habit : NSManagedObject


// Insert code here to declare functionality of your managed object subclass
+(Habit *)habitWithInfo:(NSDictionary *)habitDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;

//alertType: default, auto, manual. default always alerts, manual alerts only according to option, auto acts teh same way
//Manual requires you to manually put in dates, auto does it automatically, alert will always alert you to a date
//These are influenced by the options you select for habit alerts
//ompletedTimes: number of times you've completeed the habit
//continuing: not used. I created the red/yellow/green status instead
//date: start date of habit
//id dates: set of dates which are dates when you completed a habit
//detail: notes field
//@property (nullable, nonatomic, retain) NSString *name;
//NSData notification: localNotification stored in nsdata format
//penality: number of times you missed completeing a habit
//timesToComplete: total number of times you need to complete your habit.  Can be modified after initial creation
//dateHabitWasLastModified: used for the penality(sic) calculation.  Look in [LifePlannerHelper updateHabitWithPenality]
//@property (nullable, nonatomic, retain) Goal *goalForHabit;
//@property (nullable, nonatomic, retain) NSSet<ToDo *> *toDosForHabit;


@end

NS_ASSUME_NONNULL_END

#import "Habit+CoreDataProperties.h"
