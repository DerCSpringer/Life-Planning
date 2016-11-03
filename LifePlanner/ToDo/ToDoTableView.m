//
//  ToDoTableViewController.m
//  LifePlanner
//
//  Created by Daniel on 4/29/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "ToDoTableView.h"
#import "Habit.h"
#import "AppDelegate.h"
#import "BEMCheckBox.h"
#import "ToDoTableViewCell.h"
#import "SettingsKeys.h"
#import "AddToDoTableViewController.h"
#import "DateHelper.h"

@interface ToDoTableView () <NSFetchedResultsControllerDelegate>



@end

@implementation ToDoTableView

#pragma mark - Initialization

//Implement unwind segue


-(NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSDate *beginningOfDay = [DateHelper beginningOfDay:[NSDate date]];
        NSDate *endOfDay = [DateHelper endOfDay:[NSDate date]];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ToDo"];
        NSSortDescriptor *floatingSort = [NSSortDescriptor sortDescriptorWithKey:@"isFloating" ascending:NO];
        NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        
        request.predicate = [NSPredicate predicateWithFormat:[self predicateWithSelectedDate:[NSDate date]], beginningOfDay, endOfDay, beginningOfDay];
        
        [request setSortDescriptors:@[floatingSort, dateSort]];
        
        NSManagedObjectContext *moc = self.context; //Retrieve the main queue NSManagedObjectContext
        
        //[_fetchedResultsController setDelegate:self];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
    }
    return _fetchedResultsController;
}

- (instancetype) initWithTableView:(UITableView *)tableView{
    if (self = [super init]) {
        [self initializeFetchedResultsControllerWithDate:[NSDate date]];
        self.tableView = tableView;
        //Update tableview if settings change

    }
    return self;
}


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

- (void)initializeFetchedResultsControllerWithDate:(NSDate *)date
{
    NSDate *beginningOfDay = [DateHelper beginningOfDay:date];
    NSDate *endOfDay = [DateHelper endOfDay:date];

    NSSortDescriptor *floatingSort = [NSSortDescriptor sortDescriptorWithKey:@"isFloating" ascending:NO];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:[self predicateWithSelectedDate:beginningOfDay], beginningOfDay, endOfDay, beginningOfDay];
    //NSLog(@"%@", request.predicate);
    
    [self.fetchedResultsController.fetchRequest setSortDescriptors:@[floatingSort, dateSort]];
    
    //NSManagedObjectContext *moc = self.context; //Retrieve the main queue NSManagedObjectContext
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    //Needed this line to reload the tableview when I switched dates.  If I switch dates the database does not change because it doesn't change the data doesn't get updated in teh tableview.  This manually updates the data to be consistant with the fetched results controller.
    //A more elegant solution would be to look at the changes and do what the fetchedResultsController Delegete does
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    
    
}

-(NSString *)predicateWithSelectedDate:(NSDate *)date
{
    NSDate *beginningOfToday = [DateHelper beginningOfDay:[NSDate date]];
    NSMutableString *predicate = [[NSMutableString alloc] init];
    //Below doesn't worrk sometimes.  I can't use operators to compare dates in code. Only works in coreData
    //if (date >= beginningOfToday && date < endOfToday ) {
    
    //if floating event then show only on Today's date
    //Compares selected date to beginning of the day in the program.  These are equal times if the current date is selected.
    if ([date compare:beginningOfToday] == 0) {
        [predicate appendString:@"((date >= %@) AND (date <= %@) OR ((isFloating == YES) AND (date <= %@)))"];
    }
    else //else just display ToDos due today
    {
        [predicate appendString:@"(date >= %@) AND (date <= %@)"];
    }
    
    //Show completed items if option is selected
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:TODOS_SHOW_COMPLETED]) {
        [predicate insertString:@"(isCompleted == NO) AND " atIndex:0];
    }
    return predicate;
}


#pragma mark - Date Calculation
//Done in DateHelper



#pragma mark - UITableViewDataSource

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [tableView reloadData];
        
// Sends notification by getting a todo for the table edited then it gets the entity description. It creates a dictionary of all properties in a todo with its values
        NSEntityDescription *toDoEntity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:self.context];
        ToDo *todo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSMutableDictionary *toDoProperties = [[NSMutableDictionary alloc] init];
        [toDoProperties setObject:todo forKey:@"ToDo"];
        
        for (NSPropertyDescription *toDoInfo in toDoEntity) {
            if (![todo valueForKey:toDoInfo.name]) {
                [toDoProperties setObject:[NSNull null] forKey:toDoInfo.name];
            }
            else{
                [toDoProperties setObject:[todo valueForKey:toDoInfo.name] forKey:toDoInfo.name];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Details for ToDo" object:nil userInfo:toDoProperties];
        
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[editAction];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDo *todo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [[ToDoTableViewCell alloc] initWithToDo:todo];

    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark Navigation

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
        }
    }
    
    if ([vc isKindOfClass:[AddToDoTableViewController class]]) {
        AddToDoTableViewController *aevc = (AddToDoTableViewController*)vc;
        aevc.context = self.context;
    }
}

@end
