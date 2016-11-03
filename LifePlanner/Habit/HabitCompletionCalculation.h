//
//  HabitCompletionCalculation.h
//  LifePlanner
//
//  Created by Daniel on 7/1/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Habit.h"

@interface HabitCompletionCalculation : NSObject

@property float progress;
@property int currentWeeklyProgress;


-(instancetype)initWithHabit:(Habit *)habit;

@end
