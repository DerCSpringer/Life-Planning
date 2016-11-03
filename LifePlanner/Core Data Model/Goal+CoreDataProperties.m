//
//  Goal+CoreDataProperties.m
//  LifePlanner
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Goal+CoreDataProperties.h"

@implementation Goal (CoreDataProperties)

@dynamic date;
@dynamic detail;
@dynamic name;
@dynamic startDate;
@dynamic isCompleted;
@dynamic habitsForGoal;
@dynamic toDosForGoal;

@end
