//
//  DateHelper.m
//  LifePlanner
//
//  Created by Daniel on 6/30/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper


+ (NSDate *)beginningOfDay:(NSDate *)date
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *componentsA = [[NSDateComponents alloc] init];
    componentsA.calendar = calendar;
    
    componentsA = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    [componentsA setHour:0];
    [componentsA setMinute:0];
    [componentsA setSecond:0];
    
    
    return [calendar dateFromComponents:componentsA];
    
}

+ (NSDate *)endOfDay:(NSDate *)date
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *componentsA = [[NSDateComponents alloc] init];
    componentsA.calendar = calendar;
    
    componentsA = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    [componentsA setHour:23];
    [componentsA setMinute:59];
    [componentsA setSecond:59];
    
    
    return [calendar dateFromComponents:componentsA];
    
}

@end
