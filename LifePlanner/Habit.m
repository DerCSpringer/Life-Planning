//
//  Habit.m
//  LifePlanner
//
//  Created by Daniel on 4/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//


#import "Habit.h"
#import "Goal.h"
#import "ToDo.h"
#import "HabitDictionaryKeys.h"

@implementation Habit

// Insert code here to add functionality to your managed object subclass


+(Habit *)habitWithInfo:(NSDictionary *)habitDictionary
 inManagedObjectContext:(NSManagedObjectContext *)context

{
    Habit *habit = nil;
    
    
    NSString *habitName = [habitDictionary valueForKeyPath:HABIT_NAME ];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habit"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", habitName];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        //handle error
    }
    

    else if ([matches count])    {
//        region = [matches firstObject];
//        if (![region.photographersInRegion containsObject:photographer]) {
//            int x = [region.photographerCount intValue];
//            x++;
//            region.photographerCount = [NSNumber numberWithInt:x];
//            [region addPhotographersInRegionObject:[Photographer photographerWithName:photographerName inManagedObjectContext:context]];
//        }
    }
    
    else //create region with attributes
    {
        habit = [NSEntityDescription insertNewObjectForEntityForName:@"Habit" inManagedObjectContext:context];
        habit.name = habitName;
        habit.date = [habitDictionary valueForKey:HABIT_DATE];
        habit.continuing = [habitDictionary valueForKey:HABIT_TYPE];

        //[region addPhotographersInRegionObject:[Photographer photographerWithName:photographerName inManagedObjectContext:context]];
    }
    
    
    
    return habit;


    
}

@end
