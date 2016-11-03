//
//  LifePlannerHelper.h
//  LifePlanner
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Habit.h"

@interface LifePlannerHelper : NSObject

//auto completes a habit if the option is selected
+(void)updateHabitWithCompletionDates:(Habit *)habit;
+(void)updateHabitsWithCompletionDates:(NSArray *)habits;
+(void)updateHabitsWithPenalty:(NSArray *)habits;
+(void)updateHabitWithPenalty:(Habit *)habit;


@end
