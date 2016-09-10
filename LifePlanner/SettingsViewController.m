//
//  SettingsViewController.m
//  LifePlanner
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsKeys.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberOfCompletionTimesForHabit;
@property (weak, nonatomic) IBOutlet UISwitch *showCompletedToDos;
@property (weak, nonatomic) IBOutlet UISegmentedControl *howHabitsAreCompleted;
@property (weak, nonatomic) IBOutlet UISwitch *penalityForMissedHabit;
@property (weak, nonatomic) NSUserDefaults *defaults;

@end

@implementation SettingsViewController

- (NSUserDefaults *)defaults
{
    if (!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfCompletionTimesForHabit.text =  [NSString stringWithFormat:@"%li", (long)[self.defaults integerForKey:HABIT_NUMBER_OF_COMPLETION_TIMES]];
    self.showCompletedToDos.on = [self.defaults boolForKey:TODOS_SHOW_COMPLETED];
    self.howHabitsAreCompleted.selectedSegmentIndex = [self.defaults integerForKey:HABIT_COMPLETION_TYPE];
    //NSLog(@"%i", [self.defaults boolForKey:HABIT_PENALITY]);
    self.penalityForMissedHabit.on = [self.defaults boolForKey:HABIT_PENALITY];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.defaults setBool:self.showCompletedToDos.isOn forKey:TODOS_SHOW_COMPLETED];
    [self.defaults setBool:self.penalityForMissedHabit.isOn forKey:HABIT_PENALITY];
    [self.defaults setInteger:[self.numberOfCompletionTimesForHabit.text integerValue] forKey:HABIT_NUMBER_OF_COMPLETION_TIMES];
    //1 = left, 2 = center, 3 = right
    [self.defaults setInteger:self.howHabitsAreCompleted.selectedSegmentIndex forKey:HABIT_COMPLETION_TYPE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
