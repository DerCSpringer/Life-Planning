//
//  ToDoViewController.h
//  LifePlanner
//
//  Created by Daniel on 4/27/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendar/JTCalendar.h"
#import "ToDoTableView.h"

@interface ToDoViewController : UIViewController<JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITableView *toDoList;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *monthName;
@property (nonatomic, strong)NSDate *dateSelected;


//Present the details for a viewcontroller
-(void)loadNewScreen:(UIViewController *)controller;



@end
