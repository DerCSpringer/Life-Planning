//
//  ToDoTableViewController.h
//  LifePlanner
//
//  Created by Daniel on 4/29/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ToDoViewController.h"


@interface ToDoTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) UITableView  *tableView;

- (instancetype) initWithTableView:(UITableView *)tableView;

- (void)initializeFetchedResultsControllerWithDate:(NSDate *)date;


@end
