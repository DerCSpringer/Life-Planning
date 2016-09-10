//
//  LifePlannerHelper.m
//  LifePlanner
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "LifePlannerHelper.h"
#import "DateHelper.h"

@implementation LifePlannerHelper
//Add one day to habit.dateHabitWasLastModified.  I think check habit.dates(holds all dates a habit has been completed) to see if those dates are in habit.dates.  If not I will add them.
+(void)updateHabitWithCompletionDates:(Habit *)habit
{
    if ([habit.alertType integerValue] == 1) { // If autocomplete is selected
        NSMutableSet *set = [[NSMutableSet alloc] init]; //Dates between habit.dateHabitWasLastModified to today
        NSDate *date = [DateHelper beginningOfDay:habit.dateHabitWasLastModified];
        NSDate *beggingOfToday = [DateHelper beginningOfDay:[NSDate date]];
        //[set addObject:date];
        while (![date isEqualToDate:beggingOfToday]) { //Put all dates between last modificaiton of habit to today and see if these are completed.  If not then complete them.
            date = [date dateByAddingTimeInterval:86400];//86400 = tomorrow
            [set addObject:date];
        }
        NSEnumerator *enumerator = [set objectEnumerator];
        NSDate *dateToCheck;
        NSMutableSet *habitDate = [[NSMutableSet alloc] initWithSet:habit.dates];
        while ((dateToCheck = [enumerator nextObject])) {
            if ([habitDate containsObject:dateToCheck]) {
                continue;
            }
            else {
                [habitDate addObject:dateToCheck];
            }
        }
        habit.dates = nil;
        habit.dates = habitDate;
    }
}

+(void)updateHabitsWithCompletionDates:(NSArray *)habits
{
    for (Habit *habit in habits) {
        [self updateHabitWithCompletionDates:habit];
    }
}

//Go through all habits and if you've skipped days then add more days to the habit.  For every skipped day add 2 additional days
+(void)updateHabitWithPenalty:(Habit *)habit
{
    NSDate *date = [DateHelper beginningOfDay:habit.date];
    NSDate *beggingOfToday = [DateHelper beginningOfDay:[NSDate date]];
    NSUInteger j = 0;
    while (![date isEqualToDate:beggingOfToday]) {//Counts number of days between when you first started the habit and today
        date = [date dateByAddingTimeInterval:86400];//86400 = tomorrow
        j++;
    }
    NSUInteger numberOfTimesHabitWasSkipped = j - [habit.dates count];
    NSUInteger numberOfTimesHabitWasSkippedSinceLastChecked = j - [habit.penality integerValue];
    habit.timesToComplete = [NSNumber numberWithInt:[habit.timesToComplete integerValue] + (numberOfTimesHabitWasSkippedSinceLastChecked * 2)];
    habit.penality = [NSNumber numberWithInt:numberOfTimesHabitWasSkipped];
}


+(void)updateHabitsWithPenalty:(NSArray *)habits
{
    for (Habit *habit in habits) {
        [self updateHabitWithPenalty:habit];
    }
}



@end
