//
//  ToDoTableViewCell.m
//  LifePlanner
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "ToDoTableViewCell.h"
#import "BEMCheckBox.h"
#import "ScheduleNotification.h"
@interface ToDoTableViewCell () <BEMCheckBoxDelegate>

//I need to set this classes delegate to todotableviewcontroller


@property (strong, nonatomic) BEMCheckBox *isCompletedCheckbox;
@property (strong, nonatomic) ToDo *todo;
@property (weak, nonatomic) id<CellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

@end

@implementation ToDoTableViewCell

-(BEMCheckBox *)isCompletedCheckbox
{
    if (!_isCompletedCheckbox){
        _isCompletedCheckbox = [[BEMCheckBox alloc] init];
        _isCompletedCheckbox.delegate = self;
    }

    return _isCompletedCheckbox;
}



- (instancetype) initWithToDo:(ToDo *)todo {
    if (self = [super init]) {
        self.todo = todo;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.todo.isFloating boolValue]) {
            self.textLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            self.textLabel.textColor = [UIColor blueColor];
        }

        self.textLabel.text = todo.name;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.isCompletedCheckbox.frame=CGRectMake(8, 5, 25, 25);
        [self.contentView addSubview:self.isCompletedCheckbox];
        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.isCompletedCheckbox.trailingAnchor constant:13].active = YES;
        [self.textLabel.centerYAnchor constraintEqualToAnchor:self.isCompletedCheckbox.centerYAnchor].active = YES;

        if ([todo.isCompleted boolValue]) {
            [self.isCompletedCheckbox setOn:YES animated:YES];
        }
        else
        {
            [self.isCompletedCheckbox setOn:NO animated:YES];

        }
    }
    return self;
}

- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox
{
    if (checkBox.on) //Todo has been checked and is completed
    {
        self.todo.isCompleted = [NSNumber numberWithBool:YES];
        if (self.todo.notification) {
            [ScheduleNotification updateNotifcation:self.todo.notification toTime:nil];
        }
    }
    else //To do is unchecked possibly from showing completed to dos and unchecking
    {
        self.todo.isCompleted = [NSNumber numberWithBool:NO];
        if (self.todo.alert) {
            ScheduleNotification *notification = [[ScheduleNotification alloc] init];
            notification.alertTime = self.todo.date;
            notification.alertTitle = @"Life Plan";
            notification.alertDescription = self.todo.name;
            notification.isUserGeneratedNotification = YES;
            notification.objectName = @"ToDo";
            self.todo.notification = [notification scheduleNotificationWithTime:self.todo.alert];
        }
    }
}




- (void)awakeFromNib {
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//Updates cell after it has come out of editing state.  The auto layout seems to get messed up.
-(void)didTransitionToState:(UITableViewCellStateMask)state
{
    if (state == UITableViewCellStateDefaultMask) {
        [self setNeedsUpdateConstraints];
    }
}

@end
