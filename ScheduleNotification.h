//
//  ScheduleNotification.h
//  LifePlanner
//
//  Created by Daniel on 5/25/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Habit.h"


@interface ScheduleNotification : NSObject


//Set these three attributes then call schedule notification to schedule one.
//Notifications are already(should be) registered in the AppDelegate
@property (nonatomic, strong) NSDate *alertTime;
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *alertDescription;
@property BOOL isUserGeneratedNotification;
@property (nonatomic, strong) NSString *objectName;


- (NSData *)scheduleNotificationWithTime:(NSDate *)date;
+ (NSData *)updateNotifcation:(NSData *)notification toTime:(NSDate *)date;
+(BOOL)isUserGeneratedNotification:(NSData *)notification;
-(NSData *)scheduleRepeatingNotfication;
+(void)updateHabitAlarm:(Habit *)habit;
+(void)updateHabitAlarms:(NSArray *)habits;


@end
