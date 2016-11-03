//
//  GoalCalculation.h
//  LifePlanner
//
//  Created by Daniel on 7/8/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Goal.h"


@interface GoalCalculation : NSObject

+(UIColor *)currentGoalProgress:(Goal *)goal;
+(float)progressPercentage:(Goal *)goal;

@end
