// OLD

//  AddEntryTableViewController.m
//  LifePlanner
//
//  Created by Daniel on 6/10/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "AddToDoViewController.h"
#import "ToDo.h"
#import "ScheduleNotification.h"
#import "NameFieldTableViewCell.h"
#import "ToDoViewController.h"

@interface AddEntryTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *willAlert;
@property (weak, nonatomic) IBOutlet UISwitch *isFloating;
@property (weak, nonatomic) IBOutlet UITextView *notes;

@end

@implementation AddEntryTableViewController


#pragma mark Navigation

#define UNWIND_SEGUE_IDENTIFIER @"Do Add ToDo"


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER])
//    {
    if ([segue.destinationViewController isKindOfClass:[ToDoViewController class]] ) {
        if (self.context) {
            ToDo *todo = nil;
            if ([self.fieldsFromCell valueForKey:@"ToDo"]) {
                todo = [self.fieldsFromCell valueForKey:@"ToDo"];
            }
            else{
            todo = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo"
                                                       inManagedObjectContext:self.context];
            }
            todo.name = self.titleCell.title;
            todo.date = [self.datePicker date];
            todo.detail = self.notes.text;
            todo.isFloating = [NSNumber numberWithBool:self.isFloating.isOn];
            if ([self.notes.text isEqualToString:@"Notes"] || [self.notes.text isEqualToString:@""]) {
                todo.detail = nil;
            }
            //if I've updated teh date for the alert then delete the old notification and put in a new one for teh time
            if (!([todo.alert isEqualToDate:todo.date]) && todo.alert) {
                todo.notification = [ScheduleNotification updateNotifcation:todo.notification toTime:todo.date];
                todo.alert = todo.date;

            }
            
            //If alert is selected then set the alert time to the selected date time
            else if (self.willAlert.isOn) {
            todo.alert = todo.date;
            ScheduleNotification *notification = [[ScheduleNotification alloc] init];
            notification.alertTime = todo.date;
            notification.alertTitle = @"Life Plan";
            notification.alertDescription = todo.name;
            notification.isUserGeneratedNotification = YES;
            notification.objectName = @"ToDo";
            todo.notification = [notification scheduleNotificationWithTime:todo.alert];
            }
            //Delete notification if I turn off the alert
            else if (!self.willAlert.isOn && todo.notification)
            {
                [ScheduleNotification updateNotifcation:todo.notification toTime:nil];
                todo.notification = nil;
                todo.alert = nil;
            }
            else if (!self.willAlert.isOn)
            {
                todo.alert = nil;
            }
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 200;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


//If I selected to edit teh cell then show data for that todo
-(void)setupDetails
{
    if ([self.fieldsFromCell valueForKey:@"alert"] == [NSNull null]) {
        self.willAlert.on = NO;
    }
    else
    {
        self.willAlert.on = YES;
    }
    
    self.isFloating.on = [[self.fieldsFromCell valueForKey:@"isFloating"] boolValue];
    self.titleCell.title = [self.fieldsFromCell valueForKey:@"name"];
    if ([self.fieldsFromCell valueForKey:@"detail"] != [NSNull null]) {
        self.notes.text = [self.fieldsFromCell valueForKey:@"detail"];
        self.notes.textColor = [UIColor blackColor];
    }
    self.datePicker.date = [self.fieldsFromCell valueForKey:@"date"];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];

}

@end
