//
//  DateHelper.h
//  LifePlanner
//
//  Created by Daniel on 6/30/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)beginningOfDay:(NSDate *)date;
+ (NSDate *)endOfDay:(NSDate *)date;

@end
