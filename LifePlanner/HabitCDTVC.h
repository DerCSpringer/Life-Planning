//
//  HabitCDTVC.h
//  LifePlanner
//
//  Created by Daniel on 4/22/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "BEMCheckBox.h"
#import "CoreDataTableViewController.h"

@interface HabitCDTVC : CoreDataTableViewController

-(void)didTouchCheckBox:(BEMCheckBox *)checkBox inCell:(UITableViewCell *)cell;

@end
