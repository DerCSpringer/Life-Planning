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


@end

NS_ASSUME_NONNULL_END

#import "Habit+CoreDataProperties.h"
