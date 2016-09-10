//
//  HabitCDTVC.m
//  LifePlanner
//
//  Created by Daniel on 4/22/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "HabitCDTVC.h"
#import "AddHabitVC.h"
#import "Habit.h"
#import "AppDelegate.h"
#import "CompletionTableViewCell.h"
#import "BEMCheckBox.h"
#import "DateHelper.h"
#import "HabitCompletionCalculation.h"
@interface HabitCDTVC()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation HabitCDTVC

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
    
}

- (void)setupFetchedResultsController
{
    if (self.context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habit"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}


- (IBAction)addedHabit:(UIStoryboardSegue *)segue
{
    if (![segue.sourceViewController isKindOfClass:[AddHabitVC class]]) {
        NSLog(@"AddHabitViewController unexpectedly did not add a habit!");
        
    }
    
}
-(void)didTouchCheckBox:(BEMCheckBox *)checkBox inCell:(UITableViewCell *)cell
{
    NSDate *beginningOfToday = [DateHelper beginningOfDay:[NSDate date]];

    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    Habit *habit = [self.fetchedResultsController objectAtIndexPath:index];
    NSMutableSet *dates = [[NSMutableSet alloc] initWithSet:habit.dates];

    
    //Checks checkBox on or off state.  Then determines if it has to add todays date to it's current dates or take out today's date(if unchecked)
    if (checkBox.on) {
        if (![habit.dates containsObject:beginningOfToday]) {
            [dates addObject:beginningOfToday];
        }
    }
    else {
        if ([habit.dates containsObject:beginningOfToday]) {
            [dates removeObject:beginningOfToday];
        }
    }
    habit.dates = dates;
    
}
- (IBAction)cancelNotifications:(UIBarButtonItem *)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
//- (IBAction)cancelNotifications:(UIButton *)sender {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//}
//
//- (IBAction)displayAlerts:(UIButton *)sender {
//    
//}

- (IBAction)displayAlerts:(UIBarButtonItem *)sender {
    NSLog(@"%@",[UIApplication sharedApplication].scheduledLocalNotifications);
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompletionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Habit Cell"];
    
    Habit *habit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.title.text = habit.name;

    HabitCompletionCalculation *hcc = [[HabitCompletionCalculation alloc] initWithHabit:habit];
    cell.progressAsDecimalPercent = hcc.progress;
    cell.weeklyProgress = hcc.currentWeeklyProgress;
    if ([habit.dates containsObject:[DateHelper beginningOfDay:[NSDate date]]]) {
        cell.checked = YES;
    }
    else {
        cell.checked = NO;
    }
//    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:habit.date
//                                                               dateStyle:NSDateFormatterShortStyle
//                                                               timeStyle:NSDateFormatterNoStyle];
//
//    NSLog(@"%f",cell.isCompletedCheckbox.frame.origin.y);
//    NSLog(@"%f",cell.isCompletedCheckbox.frame.origin.x);
//    NSLog(@"%f",cell.isCompletedCheckbox.frame.size.width);
//    NSLog(@"%f",cell.isCompletedCheckbox.frame.size.height);


    //NSLog(@"%f", cell.frame.size.width);
    return cell;
}

#pragma mark - Navigation

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    // note that we don't check the segue identifier here
    // could easily imagine two different segues to ImageViewController from this class
    // for example, one might apply some sort of sepia tone or something
    // but for now, we only have this one segue, so we'll not check the segue identifier
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        UIViewController *viewController = [nvc viewControllers][0];
        if ([viewController isKindOfClass:[AddHabitVC class]]) {
            AddHabitVC *ahvc = (AddHabitVC *)viewController;
            ahvc.context = self.context;
            if ([segueIdentifer isEqualToString:@"habit details"])
            {
                NSEntityDescription *habitEntity = [NSEntityDescription entityForName:@"Habit" inManagedObjectContext:self.context];
                Habit *habit = [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSMutableDictionary *habitProperties = [[NSMutableDictionary alloc] init];
                [habitProperties setObject:habit forKey:@"Habit"];
                
                for (NSPropertyDescription *habitInfo in habitEntity) {
                    if (![habit valueForKey:habitInfo.name]) {
                        [habitProperties setObject:[NSNull null] forKey:habitInfo.name];
                    }
                    else{
                        [habitProperties setObject:[habit valueForKey:habitInfo.name] forKey:habitInfo.name];
                    }
                }
                ahvc.fieldsFromCell = habitProperties;
            }
        }

    }
}

// boilerplate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[CompletionTableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

// boilerplate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    id detailvc = [self.splitViewController.viewControllers lastObject];
//    if ([detailvc isKindOfClass:[UINavigationController class]]) {
//        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
//        [self prepareViewController:detailvc
//                           forSegue:nil
//                      fromIndexPath:indexPath];
//    }
//}

@end
