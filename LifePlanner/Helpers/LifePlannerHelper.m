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
//Add one day to habit.dateHabitWasLastModified.  Check habit.dates(holds all dates a habit has been completed) to see if those dates are in habit.dates.  If not I will add them. This happens if you selecte auto for update alerts
+(void)updateHabitWithCompletionDates:(Habit *)habit
{
    if ([habit.alertType integerValue] == 1) { // If autocomplete is selected
        NSMutableSet *set = [[NSMutableSet alloc] init]; //Dates between habit.dateHabitWasLastModified to today
        NSDate *date = [DateHelper beginningOfDay:habit.dateHabitWasLastModified];
        NSDate *beggingOfToday = [DateHelper beginningOfDay:[NSDate date]];
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
//Called at start of program and in the background
+(void)updateHabitWithPenalty:(Habit *)habit
{
    NSDate *habitStartDate = [DateHelper beginningOfDay:habit.startDate];
    NSDate *beggingOfToday = [DateHelper beginningOfDay:[NSDate date]];
    NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:habitStartDate];
    NSUInteger j = 0;
    while (![checkDate isEqualToDate:beggingOfToday]) {//Counts number of days between when you first started the habit and yesterday inclusively
        checkDate = [checkDate dateByAddingTimeInterval:86400];//86400 = tomorrow
        j++; //J = number of days between today and the day you first started the habit
    }
    __block int i = 0;
    [habit.dates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDate class]]) {
            NSDate *completedDate = (NSDate *)obj;
            if (([beggingOfToday compare:completedDate] == NSOrderedDescending && [habit.startDate compare:completedDate] == NSOrderedAscending) || ([habitStartDate compare:completedDate] == NSOrderedSame)) {
                i++;  //Numbers of completed times between today(not included) and when we first started(included).
            };
            
        }
    }];
    
    NSUInteger numberOfTimesHabitWasSkipped = j - i; //skipped between start date and yesterday inclusive
    NSInteger numberOfTimesHabitWasSkippedSinceLastChecked = numberOfTimesHabitWasSkipped - [habit.penality integerValue];
    //This also works if we update our skipped days numberOfTimesHabitWasSkippedSinceLastChecked will be negative and it will get rid of penalty
    habit.timesToComplete = [NSNumber numberWithInt:([habit.timesToComplete integerValue] + (numberOfTimesHabitWasSkippedSinceLastChecked * 2))];
    habit.penality = [NSNumber numberWithInt:numberOfTimesHabitWasSkipped];
}


+(void)updateHabitsWithPenalty:(NSArray *)habits
{
    for (Habit *habit in habits) {
        [self updateHabitWithPenalty:habit];
    }
}



@end
