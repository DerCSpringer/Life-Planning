//
//  AddGoalVC.m
//  LifePlanner
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "AddGoalVC.h"
#import "Goal.h"
#import "GoalCDTVC.h"
#import "Habit.h"
#import "CompletionTableViewCell.h"
#import "HabitCompletionCalculation.h"

@interface AddGoalVC ()
@property (weak, nonatomic) IBOutlet UIView *habitTableView;
@property (strong, nonatomic) NSMutableArray *habits;
@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (strong, nonatomic) Goal *goal;
@property (weak, nonatomic) IBOutlet UILabel *dateText;



@end

@implementation AddGoalVC


-(void)awakeFromNib
{
    [super awakeFromNib];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateText.text = [NSString stringWithFormat:@"%@", [self.dateFormatter stringFromDate:[NSDate date]]];
}

-(void)setupDetails
{
    self.titleCell.title = [self.fieldsFromCell valueForKey:@"name"];
    self.datePicker.date = [self.fieldsFromCell valueForKey:@"date"];
    if ([self.fieldsFromCell valueForKey:@"detail"] != [NSNull null]) {
        self.notes.text = [self.fieldsFromCell valueForKey:@"detail"];
        self.notes.textColor = [UIColor blackColor];
    }
    self.goal = [self.fieldsFromCell valueForKey:@"Goal"];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
}

- (NSMutableArray *)habits
{
    if (!_habits && [self.fieldsFromCell valueForKey:@"Goal"]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habit"];
        request.predicate = [NSPredicate predicateWithFormat:@"goalForHabit = %@", [self.fieldsFromCell valueForKey:@"Goal"]];
        //request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        //        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
        //                                                                  ascending:YES
        //                                                                   selector:@selector(localizedStandardCompare:)]];
        NSError *error;
        _habits = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:request error:&error]];
        
    }
    
    return _habits;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GoalCDTVC class]] ) {
        if (self.context) {
            Goal *goal = nil;
            if ([self.fieldsFromCell valueForKey:@"Goal"]) {
                goal = [self.fieldsFromCell valueForKey:@"Goal"];
            }
            else{
                goal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal"
                                                      inManagedObjectContext:self.context];
            }
            goal.name = self.titleCell.title;
            goal.date = [self.datePicker date];
            goal.detail = self.notes.text;
            if ([self.notes.text isEqualToString:@"Notes"] || [self.notes.text isEqualToString:@""]) {
                goal.detail = nil;
            }
            if (!goal.startDate) {
                goal.startDate = [NSDate date];
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    //Setup table for habits
    if (indexPath.section == 2) {
        self.progressBar = nil;
        self.cellTitle = nil;
        if ([self.habits count]) {
            Habit *habit = self.habits[indexPath.row];
            HabitCompletionCalculation *calculation = [[HabitCompletionCalculation alloc] initWithHabit:habit];
            [self setupProgressBarAutoLayout:cell];
            [self setupTitleAutoLayout:cell];
            self.progressBar.progress = calculation.progress;
            [self setWeeklyProgress:calculation.currentWeeklyProgress];
            self.cellTitle.text = habit.name;
        }
        else {
            cell.textLabel.text = @"No Associated Habits";
        }
        return cell;
    }
    
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if ([self.habits count] == 0) {
            return 1;
        }
        return [self.habits count];
    }
    else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 164;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

//I have to put this in here instead of a class because it wouldn't work in a class if I called cellForRowAtIndexPath
#pragma mark - Habit cell init

-(UIProgressView *)progressBar
{
    if (!_progressBar) _progressBar = [[UIProgressView alloc] init];
    return _progressBar;
}

-(UILabel *)cellTitle
{
    if (!_cellTitle) _cellTitle = [[UILabel alloc] init];
    return _cellTitle;
}

-(void)setWeeklyProgress:(int)weeklyProgress
{
    if (weeklyProgress < 3) {
        self.progressBar.progressTintColor = [UIColor redColor];
    }
    else if (weeklyProgress < 7) {
        self.progressBar.progressTintColor = [UIColor yellowColor];
    }
    else {
        self.progressBar.progressTintColor = [UIColor greenColor];
    }
    
}

-(void)setupTitleAutoLayout:(UITableViewCell *)cell
{
    [cell.contentView addSubview:self.cellTitle];
    self.cellTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.cellTitle.bottomAnchor constraintEqualToAnchor:self.progressBar.topAnchor].active = YES;
    [self.cellTitle.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor].active = YES;
    [self.cellTitle.leadingAnchor constraintEqualToAnchor:
     cell.contentView.leadingAnchor constant:8].active = YES;
}

-(void)setupProgressBarAutoLayout:(UITableViewCell *)cell
{
    [cell.contentView addSubview:self.progressBar];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.progressBar.trailingAnchor constraintEqualToAnchor:
     cell.contentView.trailingAnchor constant:-8].active = YES;
    
    [self.progressBar.leadingAnchor constraintEqualToAnchor:
     cell.contentView.leadingAnchor constant:8].active = YES;
    
    [self.progressBar.heightAnchor constraintEqualToConstant:10].active = YES;
    
    [self.progressBar.bottomAnchor constraintEqualToAnchor:
     cell.contentView.bottomAnchor].active = YES;
}


@end
