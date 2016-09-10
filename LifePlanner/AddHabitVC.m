//
//  AddHabitVC.m
//  LifePlanner
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "AddHabitVC.h"
#import "Habit.h"
#import "HabitCDTVC.h"
#import "Goal.h"
#import "ScheduleNotification.h"

@interface AddHabitVC () <UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
    NSMutableArray *_datesSelected;
}
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completionType;
@property (strong,nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet UIPickerView *selectAssociatedGoal;
@property (strong, nonatomic) NSMutableArray *goals;

@property (weak, nonatomic) IBOutlet UITextField *habitRepititions;
@property (weak, nonatomic) IBOutlet UIDatePicker *alertTime;
@end


@implementation AddHabitVC


#define UNWIND_SEGUE_IDENTIFIER @"Do Add Habit"

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectAssociatedGoal.delegate = self;
    self.selectAssociatedGoal.dataSource = self;
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    
    // Generate random events sort by date using a dateformatter for the demonstration
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    _datesSelected = [NSMutableArray new];
//    self.completionType.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.completionType.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:8].active = YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[HabitCDTVC class]] ) {
        if (self.context) {
            Habit *habit = nil;
            if ([self.fieldsFromCell valueForKey:@"Habit"]) {
                habit = [self.fieldsFromCell valueForKey:@"Habit"];
            }
            else{
                habit = [NSEntityDescription insertNewObjectForEntityForName:@"Habit"
                                                     inManagedObjectContext:self.context];
            }
            habit.name = self.titleCell.title;
            //habit.date is the alert time each day the habit will fire if selected
            habit.date = self.alertTime.date;
            habit.dates = [NSSet setWithArray:_datesSelected];
            habit.alertType = [NSNumber numberWithInt:self.completionType.selectedSegmentIndex];
            habit.timesToComplete = [NSNumber numberWithInteger:[self.habitRepititions.text integerValue]];
            habit.detail = self.notes.text;
            if ([self.notes.text isEqualToString:@"Notes"] || [self.notes.text isEqualToString:@""]) {
                habit.detail = nil;
            }
            habit.dateHabitWasLastModified = [NSDate date];
            //Makes sure there is more than zero goals to be selected and if that's true then it assocaites the goal with the selected habit
            if ([self.selectAssociatedGoal selectedRowInComponent:0] == 0) {
                habit.goalForHabit = nil;
            }
            else if ([self.goals[[self.selectAssociatedGoal selectedRowInComponent:0] - 1] isKindOfClass:[Goal class]]) {
                habit.goalForHabit = self.goals[[self.selectAssociatedGoal selectedRowInComponent:0] - 1];
            }
            //if I've updated teh date for the alert then delete the old notification and put in a new one for teh time
            //Checks to make sure I've updated the date && there is old data being modified && that I've selected the alert segment && that I currently have a notification to update
            if (!(habit.date == [self.fieldsFromCell valueForKey:@"date"]) && self.fieldsFromCell && self.completionType.selectedSegmentIndex == 0 && habit.notification) {
                habit.notification = [ScheduleNotification updateNotifcation:habit.notification toTime:habit.date];
            }
            
            //If alert is selected and I don't already have a notification then set the alert time to the selected date time
            else if (self.completionType.selectedSegmentIndex == 0 && !habit.notification) {
                ScheduleNotification *notification = [[ScheduleNotification alloc] init];
                notification.alertTime = habit.date;
                notification.alertTitle = @"Life Plan";
                notification.alertDescription = habit.name;
                notification.isUserGeneratedNotification = YES;
                notification.objectName = @"Habit";
                habit.notification = [notification scheduleRepeatingNotfication];
            }
            
            //Delete notification if I turn off the alert
            else if (self.completionType.selectedSegmentIndex != 0 && habit.notification)
            {
                habit.notification = [ScheduleNotification updateNotifcation:habit.notification toTime:nil];
            }
            
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 140;
    }
    if (indexPath.section == 4) {
        return 200;
    }
    else if (indexPath.section == 5) {
        return 200;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

//Fills up the fields with information from the database if you've selected an entry to edit
-(void)setupDetails
{
    self.titleCell.title = [self.fieldsFromCell valueForKey:@"name"];
    self.alertTime.date = [self.fieldsFromCell valueForKey:@"date"];
    [_datesSelected addObjectsFromArray:[[self.fieldsFromCell valueForKey:@"dates"] allObjects]];
    self.completionType.selectedSegmentIndex = [[self.fieldsFromCell valueForKey:@"alertType"] integerValue];
    self.habitRepititions.text = [[self.fieldsFromCell valueForKey:@"timesToComplete"] stringValue];
    if ([self.fieldsFromCell valueForKey:@"detail"] != [NSNull null]) {
        self.notes.text = [self.fieldsFromCell valueForKey:@"detail"];
        self.notes.textColor = [UIColor blackColor];
    }
    if ([self.goals containsObject:[self.fieldsFromCell valueForKey:@"goalForHabit"]]) {
        [self.selectAssociatedGoal selectRow:[self.goals indexOfObject:[self.fieldsFromCell valueForKey:@"goalForHabit"]] + 1  inComponent:0 animated:YES];
    }
    
    [self.calendarManager reload];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
}
#pragma mark - associated goal picker



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.goals count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"None";
    }
    else {
        NSString *goalName = [[NSString alloc] init];
        Goal *goal = self.goals[row - 1];
        goalName = goal.name;
        return goalName;
    }
}

- (NSMutableArray *)goals
{
    if (!_goals) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Goal"];
        //request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        //        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
        //                                                                  ascending:YES
        //                                                                   selector:@selector(localizedStandardCompare:)]];
        NSError *error;
        _goals = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:request error:&error]];
        
    }
    
    return _goals;
}


#pragma mark - CalendarDelegate


- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        //if today is not selcted
        if ([self isInDatesSelected:dayView.date]) {
            dayView.circleView.backgroundColor = [UIColor greenColor];
            dayView.dotView.backgroundColor = [UIColor whiteColor];
            dayView.textLabel.textColor = [UIColor whiteColor];
        }
        //if today is selected
        else
        {
            dayView.circleView.backgroundColor = [UIColor whiteColor];
            dayView.dotView.backgroundColor = [UIColor redColor];
            dayView.textLabel.textColor = [UIColor redColor];
        }
    }
    // Selected date
    else if([self isInDatesSelected:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor greenColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if([self isInDatesSelected:dayView.date]){
        [_datesSelected removeObject:dayView.date];
        
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                        } completion:nil];
    }
    else{
        [_datesSelected addObject:dayView.date];
        
        dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformIdentity;
                        } completion:nil];
    }
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}



@end
