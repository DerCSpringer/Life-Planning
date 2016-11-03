//
//  OptionsVC.m
//  LifePlanner
//
//  Created by Daniel on 6/22/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "OptionsVC.h"
#import "SettingsKeys.h"
#import "ScheduleNotification.h"
#import "Habit.h"
#import "AppDelegate.h"

@interface OptionsVC () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *showCompletedGoals;
@property (weak, nonatomic) IBOutlet UISwitch *showCompletedToDos;
@property (weak, nonatomic) IBOutlet UISegmentedControl *howHabitsAreCompleted;
@property (weak, nonatomic) IBOutlet UISwitch *penalityForMissedHabit;
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UISwitch *habitAlerts;
@end


@implementation OptionsVC
- (NSUserDefaults *)defaults
{
    if (!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.showCompletedToDos.on = [self.defaults boolForKey:TODOS_SHOW_COMPLETED];
    [self reloadInputViews];
    self.howHabitsAreCompleted.selectedSegmentIndex = [self.defaults integerForKey:HABIT_COMPLETION_TYPE];
    self.habitAlerts.on = [self.defaults boolForKey:HABIT_ALERTS];
    self.penalityForMissedHabit.on = [self.defaults boolForKey:HABIT_PENALITY];
    self.showCompletedGoals.on = [self.defaults boolForKey:GOALS_SHOW_COMPLETED];
    [self.habitAlerts addTarget:self action:@selector(reloadInputViews) forControlEvents:UIControlEventTouchUpInside];
}

-(void)reloadInputViews
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.defaults setBool:self.showCompletedToDos.isOn forKey:TODOS_SHOW_COMPLETED];
    [self.defaults setBool:self.penalityForMissedHabit.isOn forKey:HABIT_PENALITY];
    //0 = red, 1 = red/yellow, 2 = default
    [self.defaults setInteger:self.howHabitsAreCompleted.selectedSegmentIndex forKey:HABIT_COMPLETION_TYPE];
    [self.defaults setBool:self.habitAlerts.isOn forKey:HABIT_ALERTS];
    [self.defaults setBool:self.showCompletedGoals.isOn forKey:GOALS_SHOW_COMPLETED];
    //If habit alerts is off then I need to delete all alerts for habits
    //If it's on I need to see what key is selected then do stuff
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = app.managedObjectContext;
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habit"];
    NSMutableArray *habits = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    //Turn off all habit alerts if habit alert is not selected
    if (![[self.defaults valueForKey:HABIT_ALERTS] boolValue]) {
        for (Habit *habit in habits) {
            [ScheduleNotification updateNotifcation:habit.notification toTime:nil];
        }
    }
    //Turn on habit alerts if habit alert is selected and you wanted to be alerted for a specific habit.
    if ([self.defaults boolForKey:HABIT_ALERTS] && [self.defaults integerForKey:HABIT_COMPLETION_TYPE] == 2) {
        for (Habit *habit in habits) {
            if (habit.alertType == [NSNumber numberWithInt:0]) {
                [ScheduleNotification updateNotifcation:habit.notification toTime:habit.date];
            }
        }
    }
    if ([[self.defaults valueForKey:HABIT_ALERTS] boolValue] && [@[[NSNumber numberWithInt:0],[NSNumber numberWithInt:1]] containsObject:[self.defaults valueForKey:HABIT_COMPLETION_TYPE]]) {// HABIT_COMPLETION_TYPE is 0 or 1
        [ScheduleNotification updateHabitAlarms:habits];
    }
    else if ([[self.defaults valueForKey:HABIT_ALERTS] boolValue] && [self.defaults valueForKey:HABIT_COMPLETION_TYPE] == [NSNumber numberWithInt:2]) {
        [ScheduleNotification updateHabitAlarms:habits];

    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == 1 && indexPath.section == 1 && !self.habitAlerts.isOn) {
        height = 0;
    }
    
    
    return height;
}




@end
