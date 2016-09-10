//
//  ItemCDTVC.h
//  LifePlanner
//
//  Created by Daniel on 5/26/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "BEMCheckBox.h"

@interface GoalCDTVC : CoreDataTableViewController

-(void)didTouchCheckBox:(BEMCheckBox *)checkBox inCell:(UITableViewCell *)cell;


@end
