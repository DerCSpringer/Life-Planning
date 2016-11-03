//
//  HabitCompletionCalculation.m
//  LifePlanner
//
//  Created by Daniel on 7/1/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "HabitCompletionCalculation.h"
#import "DateHelper.h"
@interface HabitCompletionCalculation ()
@property (nonatomic, strong) Habit *habit;
@end

@implementation HabitCompletionCalculation


-(instancetype)initWithHabit:(Habit *)habit
{
    self.habit = habit;
    self.progress = [habit.dates count] / [habit.timesToComplete floatValue];
    self.currentWeeklyProgress = [self completedTimesInLastWeek];
    return self;
}

//Returns the number of times you've done a habit in the past seven days
-(int)completedTimesInLastWeek
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    NSDate *date = [DateHelper beginningOfDay:[NSDate date]];
    [set addObject:date];
    for (int i = 0; i < 6; i++) {
        date = [date dateByAddingTimeInterval:-86400];
        [set addObject:date];
    }
    int j = 0;
    
    NSEnumerator *enumerator = [self.habit.dates objectEnumerator];
    NSDate *dateToCheck;
    
    while ((dateToCheck = [enumerator nextObject])) {
        if ([set containsObject:dateToCheck]) {
            j++;
        }
    }
    return j;
}

@end
