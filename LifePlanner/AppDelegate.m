//
//  AppDelegate.m
//  LifePlanner
//
//  Created by Daniel on 4/21/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "AppDelegate.h"
#import "Habit.h"
#import "ScheduleNotification.h"
#import "HabitCompletionCalculation.h"
#import "SettingsKeys.h"
#import "LifePlannerHelper.h"
#import <objc/runtime.h>
#import "HabitCDTVC.h"
#import "ToDoViewController.h"

@interface AppDelegate ()




@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    //update all habit.dates if auto is selected
    NSArray *habits = [self fetchHabits];
    [LifePlannerHelper updateHabitsWithCompletionDates:habits];
#warning if someone updates manual this doesn't work so great because what if they update that they didn't skip any days?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:HABIT_PENALITY]) {
        [LifePlannerHelper updateHabitsWithPenalty:habits];
    }
    [self displayViewControllerForNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey] application:application];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
#warning update habit alerts here too(turn off or on).  I need to do this if I've updated the number of times I've completed a habit
    [self saveContext];
}

-(void)displayViewControllerForNotification:(UILocalNotification *)notification application:(UIApplication *)application
{
    if (notification == nil) {
        return;
    }
    if ([[notification.userInfo valueForKey:@"Object"] isEqualToString:@"Habit"]) {
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            tab.selectedIndex = 1;
        }
    }
    else if ([[notification.userInfo valueForKey:@"Object"] isEqualToString:@"ToDo"]) {
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            tab.selectedIndex = 0;
        }
        
    }
    else { //Computer generated alerts are always habit alerts(which don't have an object name) so just open if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        tab.selectedIndex = 1;
    }

}
-(NSArray *)fetchHabits
{
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habit"];
    NSMutableArray *habits = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    return habits;
    
}

#define BACKGROUND_ALERT_UPDATE_TIMEOUT (10)

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *habits = [self fetchHabits];

    //Updates habits with completed times if auto options is selected for habit
    [LifePlannerHelper updateHabitsWithCompletionDates:habits];
    //If I have habit alerts allowed and I've selected alert on red or yellow then do this
    if (self.managedObjectContext && [[defaults valueForKey:HABIT_ALERTS] boolValue] && [@[[NSNumber numberWithInt:0],[NSNumber numberWithInt:1]] containsObject:[defaults valueForKey:HABIT_COMPLETION_TYPE]]) {// HABIT_COMPLETION_TYPE is 0 or 1
        
        [ScheduleNotification updateHabitAlarms:habits];
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData); // no app-switcher update if no database!
    }
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "dcs.LifePlanner" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LifePlanner" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LifePlanner.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
