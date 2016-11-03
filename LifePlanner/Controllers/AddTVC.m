//
//  AddTVC.m
//  LifePlanner
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "AddTVC.h"
#import "NameFieldTableViewCell.h"
#import "AppDelegate.h"
#import "Habit.h"
#import "ToDo.h"
#import "ScheduleNotification.h"

@interface AddTVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>
@property BOOL textInNameField;
@property BOOL isEditing;
@property id entityToDelete;
@end

//The first 2 sections are assumed to be a title and a date.  These are always displayed and implemented here.
//The last section with only 1 row is always the delete section
//Inherited for tables who want to add things
//Abstract class
@implementation AddTVC

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.datePicker.date = [NSDate date];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
//List of all types of entities in the database
-(NSArray *)entities
{
    if (!_entities)  _entities = @[@"ToDo", @"Habit", @"Goal"];
    
    return _entities;
}

//Shouldn't need to be called.  I needed to put this in because it said I had a forward declaration if I didn't
-(NSManagedObjectContext *)context
{
    if (!_context) {
        UIApplication *application = [[UIApplication sharedApplication] delegate];
        
        if ([application isKindOfClass:[AppDelegate class]]) {
            AppDelegate *app = (AppDelegate *)application;
            _context = app.managedObjectContext;
        }
        else
        {
            _context = nil;
        }
    }
    return _context;
}



-(NameFieldTableViewCell *)titleCell
{
    if (!_titleCell){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        if ([cell isKindOfClass:[NameFieldTableViewCell class]]) {
            _titleCell = (NameFieldTableViewCell *)cell;
        }
    }
    
    return _titleCell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    //Shows selected date or current date in cell
    if (self.fieldsFromCell) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.dateFormatter stringFromDate:[self.fieldsFromCell valueForKey:@"date"]]];
        self.datePicker.date = [self.fieldsFromCell valueForKey:@"date"];
        //Sets nsnumber value of no if the first item isn't an entity from coreDate
        NSArray *arrayOfEntities = [self.fieldsFromCell objectsForKeys:self.entities notFoundMarker:[NSNumber numberWithBool:NO]];
        //Checks to see if I'm editing an entry if so it sets the selected date to the date in the database
        //I use an array of all the entity names in my database as delcared above.  It checks to see if any of  those entity names are in the dictionary(fields contain the entity name along with its data).
        
        AddTVC * __weak weakSelf = self;
        [arrayOfEntities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[NSNumber class]]) {
                weakSelf.datePicker.date = [weakSelf.fieldsFromCell valueForKey:@"date"];
                [weakSelf setupDetails];
                weakSelf.isEditing = YES;
                weakSelf.entityToDelete = obj;
            }
        }];
    }
}

-(void)setupDetails
{
    //Abstract class
    //Setup all fields except the title and date field
}

- (UIDatePicker *)datePicker{
    if(!_datePicker) _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    return _datePicker;
}

-(void)deleteEntry
{
    if (self.context)
    {
        if ([self.entityToDelete isKindOfClass:[Habit class]]) {
            Habit *habit = (Habit *)self.entityToDelete;
            [ScheduleNotification updateNotifcation:habit.notification toTime:nil];
        }
        else if ([self.entityToDelete isKindOfClass:[ToDo class]]) {
            ToDo *todo = (ToDo *)self.entityToDelete;
            [ScheduleNotification updateNotifcation:todo.notification toTime:nil];
        }
        [self.context deleteObject:self.entityToDelete];
        [self cancel];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If i select the date cell it will expand the one below to select a date
    if (self.datePickerIsShowing == NO && indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell *datePickerCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
        [datePickerCell.contentView addSubview:self.datePicker];
        
        self.datePickerIsShowing = YES;
        [tableView beginUpdates];

        [tableView endUpdates];

    } else
    {
        self.datePickerIsShowing = NO;
        
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].detailTextLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
        
        [tableView beginUpdates];
        [tableView endUpdates];
        [self.tableView reloadData];
    }
    
    if (indexPath.section == (self.tableView.numberOfSections - 1)) {
        [self alert:@"Are you sure you want to delete?"];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = self.tableView.rowHeight;
    
    //if date picker is showing then expand row to show it
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (self.datePickerIsShowing){
            rowHeight = 164;
        }
        else {
            rowHeight = 0;
        }
    }

    if (indexPath.section == self.tableView.numberOfSections - 1 && !self.isEditing) {
        rowHeight = 0;
    }

    return rowHeight;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Notes";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

//I need to do this becuase if titleCell goes off screen it sets it to nil.  This makes sure that doesn't happen only to this cell.
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath

{
    if ([cell isKindOfClass:[NameFieldTableViewCell class]]) {
        NameFieldTableViewCell *cell2 = (NameFieldTableViewCell *)cell;
        self.titleCell = cell2;
    }
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self.titleCell.title length]) {
        [self alert:@"Please enter a title."];
        return NO;
    }
    else {
        return YES;
    }
}


- (void)alert:(NSString *)msg
{
    //NSString *add = [[NSString alloc] initWithFormat:(@"%@", self.navigationItem.title)];
    NSString *add = [[NSString alloc] initWithString:self.navigationItem.title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:add message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self cancel];}];
    if ([msg isEqualToString:@"Are you sure you want to delete?"]) {
        alert = [UIAlertController alertControllerWithTitle:@"DELETE" message:msg preferredStyle:UIAlertControllerStyleAlert];
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {[self deleteEntry];}];
        cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
    }
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

