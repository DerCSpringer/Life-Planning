//
//  ItemCDTVC.m
//  LifePlanner
//
//  Created by Daniel on 5/26/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "GoalCDTVC.h"
#import "Goal.h"
#import "AppDelegate.h"
#import "CompletionTableViewCell.h"
#import "AddGoalVC.h"
#import "GoalCalculation.h"
#import "SettingsKeys.h"

@interface GoalCDTVC ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation GoalCDTVC



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
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self setupFetchedResultsController];
                                                  }];
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if (self.context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Goal"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:GOALS_SHOW_COMPLETED]) {
            request.predicate = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
        }
        
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}


- (IBAction)addedGoal:(UIStoryboardSegue *)segue
{
    if (![segue.sourceViewController isKindOfClass:[AddGoalVC class]]) {
        NSLog(@"AddGoalViewController unexpectedly did not add a goal!");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)didTouchCheckBox:(BEMCheckBox *)checkBox inCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:index];
    if (checkBox.on) {
        goal.isCompleted = [NSNumber numberWithBool:YES];
    }
    else {
        goal.isCompleted = [NSNumber numberWithBool:NO];
    }
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompletionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Goal Cell"];
    
    Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = [GoalCalculation currentGoalProgress:goal];
    cell.title.text = goal.name;
    cell.progressAsDecimalPercent = [GoalCalculation progressPercentage:goal];
    cell.checked = [goal.isCompleted boolValue];
    return cell;
}

#pragma mark - Navigation

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        UIViewController *viewController = [nvc viewControllers][0];
        if ([viewController isKindOfClass:[AddGoalVC class]]) {
            AddGoalVC *ahvc = (AddGoalVC *)viewController;
            ahvc.context = self.context;
            if ([segueIdentifer isEqualToString:@"goal details"])
            {
                NSEntityDescription *goalEntity = [NSEntityDescription entityForName:@"Goal" inManagedObjectContext:self.context];
                Goal *goal = [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSMutableDictionary *goalProperties = [[NSMutableDictionary alloc] init];
                [goalProperties setObject:goal forKey:@"Goal"];
                
                //Looks at all attributes for an entity and puts them all into a dictionary
                //I should put then into a category later for each entity
                for (NSPropertyDescription *goalInfo in goalEntity) {
                    if (![goal valueForKey:goalInfo.name]) {
                        [goalProperties setObject:[NSNull null] forKey:goalInfo.name];
                    }
                    else{
                        [goalProperties setObject:[goal valueForKey:goalInfo.name] forKey:goalInfo.name];
                    }
                }
                
                ahvc.fieldsFromCell = goalProperties;
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


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



