//
//  ToDoViewController.m
//  LifePlanner
//
//  Created by Daniel on 4/27/16.
//  Copyright © 2016 Daniel. All rights reserved.
////
//
#import "ToDoViewController.h"
#import "AppDelegate.h"
#import "ToDoTableView.h"
#import "BEMCheckBox.h"
#import "AddToDoTableViewController.h"
#import "ToDoTableViewCell.h"

@interface ToDoViewController()

@property (nonatomic, strong)NSDate *todaysDate;
@property (nonatomic) ToDoTableView *tableViewList;
@property (nonatomic, strong) NSMutableDictionary *details;


@end

@implementation ToDoViewController


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

-(void)setDateSelected:(NSDate *)dateSelected {
    _dateSelected = dateSelected;
    [self.tableViewList initializeFetchedResultsControllerWithDate:_dateSelected];
    [self.calendarManager reload];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableViewList initializeFetchedResultsControllerWithDate:_dateSelected];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTodaysDate)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //This allows me to have the tableview's delegate in a seperate class
    self.tableViewList = [[ToDoTableView alloc] initWithTableView:self.toDoList];
    self.toDoList.delegate = self.tableViewList;
    self.toDoList.dataSource = self.tableViewList;
    
    //init tableview object but just put fetched results controller in init

    
    
    self.todaysDate = [NSDate date];

    self.calendarManager = [JTCalendarManager new];

    self.calendarManager.delegate = self;
    
    self.calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    self.calendarManager.settings.weekModeEnabled = YES;
    [self.calendarManager setMenuView:self.monthName];


    
    [self.calendarManager reload];

    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:self.todaysDate];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"Details for ToDo" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self displayDetails:note];
    }];
}

//If the application is inactive and becomes active then update the view
-(void)updateTodaysDate
{
    self.todaysDate = [NSDate date];
    [self.calendarManager setDate:self.todaysDate];
    self.dateSelected = self.todaysDate;
}

//Prepares the view for each day.  This is the view at the top of the calendar(the blue circles and red circles).
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    
    if (!_dateSelected) {
        _dateSelected = [NSDate date];
    }
    
    // Today
    // Circle View is what's behind the dot
    // Dotview is the actual dot
    if([_calendarManager.dateHelper date:self.todaysDate isTheSameDayThan:dayView.date]){

        // If today's date is not selected.
        if (![self.calendarManager.dateHelper date:self.todaysDate isTheSameDayThan:_dateSelected]) {
            dayView.textLabel.textColor = [UIColor redColor];
            dayView.circleView.backgroundColor = [UIColor clearColor];

        }
        else
        {
            dayView.circleView.hidden = NO;
            dayView.circleView.backgroundColor = [UIColor redColor];
            dayView.dotView.backgroundColor = [UIColor redColor];
            dayView.textLabel.textColor = [UIColor whiteColor];
        }
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
        dayView.dotView.hidden = YES;
    
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    self.dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
}

- (IBAction)addedToDo:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[AddToDoTableViewController class]]) {
        AddToDoTableViewController *aevc = (AddToDoTableViewController *)segue.sourceViewController;
    }
    else {
        NSLog(@"AddEntryTableViewController unexpectedly did not add a ToDo!");
    }
    
}

#pragma mark - Navigation

-(void)displayDetails:(NSNotification *)note
{
    if ([note.userInfo isKindOfClass:[NSDictionary class]]) {
        [self.details setDictionary:note.userInfo];
        [self performSegueWithIdentifier:@"Details" sender:self];
    }

}



- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        UIViewController *viewController = [nvc viewControllers][0];
        if ([viewController isKindOfClass:[AddToDoTableViewController class]]) {
            AddToDoTableViewController *aevc = (AddToDoTableViewController*)viewController;
            aevc.context = self.context;
            if ([segueIdentifer isEqualToString:@"Do Add ToDo"]) {
                self.details = nil;
                self.details = [[NSMutableDictionary alloc] init];
                [self.details setValue:self.dateSelected forKey:@"date"];
            }
            aevc.fieldsFromCell = self.details;
            
        }

    }
    
    if ([vc isKindOfClass:[AddToDoTableViewController class]]) {
        AddToDoTableViewController *aevc = (AddToDoTableViewController*)vc;
        aevc.context = self.context;
    }
}

// boilerplate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    //    if ([sender isKindOfClass:[AddHabitViewController class]]) {
    //        indexPath = [self.tableView indexPathForCell:sender];
    //    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

-(void)loadNewScreen:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
