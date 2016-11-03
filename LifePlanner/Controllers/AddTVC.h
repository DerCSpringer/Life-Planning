//
//  AddTVC.h
//  LifePlanner
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameFieldTableViewCell.h"

@interface AddTVC : UITableViewController
//Abstract


@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSDictionary *fieldsFromCell;

@property (nonatomic) BOOL datePickerIsShowing;
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NameFieldTableViewCell *titleCell;
@property (strong, nonatomic) NSArray *entities;


@end
