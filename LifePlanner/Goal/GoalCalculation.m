//
//  GoalCalculation.m
//  LifePlanner
//
//  Created by Daniel on 7/8/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "GoalCalculation.h"
#import "Habit.h"
#import "HabitCompletionCalculation.h"

@implementation GoalCalculation

//Returns a color for a goal.  This corresponds to how well you're doing when you average all the habits associated with a goal.
//Might want to change this return to int to conform to mvc
+(UIColor *)currentGoalProgress:(Goal *)goal
{
    int __block numberOfCompletedTimes = 0;
    [goal.habitsForGoal enumerateObjectsUsingBlock:^(Habit * _Nonnull obj, BOOL * _Nonnull stop) {
        Habit *habit = (Habit *)obj;
        HabitCompletionCalculation *calculation = [[HabitCompletionCalculation alloc] initWithHabit:habit];
        numberOfCompletedTimes += calculation.currentWeeklyProgress;
    }];
    if ([goal.habitsForGoal count] == 0) {
        return [UIColor whiteColor];
    }
    float habitCompletion = ((float)numberOfCompletedTimes / ((float)([goal.habitsForGoal count] * 7)));
    
    if (habitCompletion > 0.85) {
        return [UIColor greenColor];
    }
    else if (habitCompletion > 0.50) {
        return [UIColor yellowColor];
    }
    else {
        return [UIColor redColor];
    }
}

//Returns the current progress for a goal.  This is the progress in teh progressBar
+(float)progressPercentage:(Goal *)goal
{
    float startingTime = [goal.date timeIntervalSinceDate:goal.startDate];
    float currentTime = [[NSDate date] timeIntervalSinceDate:goal.startDate];
    return (currentTime / startingTime);
}


@end
