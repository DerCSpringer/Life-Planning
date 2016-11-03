//
//  ScheduleNotification.m
//  LifePlanner
//
//  Created by Daniel on 5/25/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "ScheduleNotification.h"
#import "SettingsKeys.h"
#import "HabitCompletionCalculation.h"


@implementation ScheduleNotification



+(BOOL)isUserGeneratedNotification:(NSData *)notification {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (notification) {
        localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:notification];
    }
    else {
        return false;
    }
    if ([localNotif.userInfo valueForKey:@"isUserGeneratedNotification"] == [NSNumber numberWithBool:YES]) {
        return true;
    }
    else {
        return false;
    }
}

- (NSData *)scheduleNotificationWithTime:(NSDate *)date {

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return nil;
    localNotif.fireDate = date;
    localNotif.alertBody = self.alertDescription;
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertTitle = self.alertTitle;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    if (self.isUserGeneratedNotification) {
        NSDictionary *uiq = [[NSDictionary alloc] initWithObjects:@[[[NSUUID UUID] UUIDString], [NSNumber numberWithBool:YES]] forKeys:@[@"id", @"isUserGeneratedNotification"]];
        [userInfo setDictionary:uiq];
    }
    else {
        NSDictionary *uiq = [[NSDictionary alloc] initWithObjects:@[[[NSUUID UUID] UUIDString], [NSNumber numberWithBool:NO]] forKeys:@[@"id", @"isUserGeneratedNotification"]];
        [userInfo setDictionary:uiq];
    }
    [userInfo setValue:self.objectName forKey:@"Object"];
    localNotif.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotif];
    return data;
}

+ (NSData *)updateNotifcation:(NSData *)notification toTime:(NSDate *)date
{

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    UIApplication *app = [UIApplication sharedApplication];
    if (notification) {
        localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:notification];
    }
    NSArray *notifications = [app scheduledLocalNotifications];
    UILocalNotification *note = [[UILocalNotification alloc] init];
    
    for (note in notifications) {
        if ([[note.userInfo valueForKey:@"id"] isEqualToString:[localNotif.userInfo valueForKey:@"id"]]) {
            [app cancelLocalNotification:note];
        }
    }
    
    if (date == nil) { //If date is nil then delete notification
        notification = nil;
        return notification;
    }
    localNotif.fireDate = date;
    [app scheduleLocalNotification:localNotif];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotif];
    return data;
}

-(NSData *)scheduleRepeatingNotfication
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    if (localNotif == nil)
        return nil;
    localNotif.fireDate = self.alertTime;
    
    localNotif.alertBody = self.alertDescription;
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertTitle = self.alertTitle;
    localNotif.repeatInterval = NSCalendarUnitDay;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    if (self.isUserGeneratedNotification) {
        NSDictionary *uiq = [[NSDictionary alloc] initWithObjects:@[[[NSUUID UUID] UUIDString], [NSNumber numberWithBool:YES]] forKeys:@[@"id", @"isUserGeneratedNotification"]];
        [userInfo setDictionary:uiq];
    }
    else {
        NSDictionary *uiq = [[NSDictionary alloc] initWithObjects:@[[[NSUUID UUID] UUIDString], [NSNumber numberWithBool:NO]] forKeys:@[@"id", @"isUserGeneratedNotification"]];
        [userInfo setDictionary:uiq];
    }
    [userInfo setValue:self.objectName forKey:@"Object"];
    localNotif.userInfo= userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotif];
    return data;
}

//updates alerts if red or red/yellow alerts are selected in options.  It updates them also if you're doing better and don't need an alert(on green or yellow(if red is selected))



+(void)updateHabitAlarm:(Habit *)habit
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults valueForKey:HABIT_ALERTS] boolValue]) {
        habit.notification = nil;
    }
        if ([[defaults valueForKey:HABIT_COMPLETION_TYPE] integerValue] == 0) { //Red is selected for habit alerts
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (habit.notification) {
                localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:habit.notification];
            }

            if ([[HabitCompletionCalculation alloc] initWithHabit:habit].currentWeeklyProgress < 3 && !habit.notification ) { //If habit is red status and we don't have a habit then schedule one
                ScheduleNotification *notification = [[ScheduleNotification alloc] init];
                notification.alertTime = habit.date;
                notification.alertTitle = @"Life Plan";
                notification.alertDescription = habit.name;
                notification.isUserGeneratedNotification = NO;
                habit.notification = [notification scheduleRepeatingNotfication];
            }
            else if ([[HabitCompletionCalculation alloc] initWithHabit:habit].currentWeeklyProgress >= 3){ //If we are doing better delete habit
                habit.notification = [ScheduleNotification updateNotifcation:habit.notification toTime:nil];
            }
            
        }
        else if ([[defaults valueForKey:HABIT_COMPLETION_TYPE] integerValue] == 1) { //If red/yellow habit alert option is slected

            if ([[HabitCompletionCalculation alloc] initWithHabit:habit].currentWeeklyProgress < 7 && !habit.notification) { //If habit is red or yellow status
                ScheduleNotification *notification = [[ScheduleNotification alloc] init];
                notification.alertTime = habit.date;
                notification.alertTitle = @"Life Plan";
                notification.alertDescription = habit.name;
                notification.isUserGeneratedNotification = NO;
                habit.notification = [notification scheduleRepeatingNotfication];
                
            }
            else if ([[HabitCompletionCalculation alloc] initWithHabit:habit].currentWeeklyProgress >= 7){ //Delete notification if we're doing better
                habit.notification = [ScheduleNotification updateNotifcation:habit.notification toTime:nil];
            }

        }
        else if ([[defaults valueForKey:HABIT_COMPLETION_TYPE] integerValue] == 2 && [habit.alertType integerValue]) {//Delete notifications if they are created because of a habit being in green or yellow and we've only selected default alerts
                habit.notification = [self updateNotifcation:habit.notification toTime:nil];

        }
        else if ([habit.alertType integerValue] == 0 && !habit.notification) { //If we have habit alert selected and default is selected make sure we have an alert
            ScheduleNotification *notification = [[ScheduleNotification alloc] init];
            notification.alertTime = habit.date;
            notification.alertTitle = @"Life Plan";
            notification.alertDescription = habit.name;
            notification.isUserGeneratedNotification = NO;
            habit.notification = [notification scheduleRepeatingNotfication];
        }
    


}

+(void)updateHabitAlarms:(NSArray *)habits
{
    for (Habit *habit in habits) {
        [self updateHabitAlarm:habit];
    }
}
@end
