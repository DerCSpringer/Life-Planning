//
//  HabitTableViewCell.m
//  LifePlanner
//
//  Created by Daniel on 5/25/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "CompletionTableViewCell.h"
#import "BEMCheckBox.h"
#import "HabitCDTVC.h"
#import "GoalCDTVC.h"

@interface CompletionTableViewCell () <BEMCheckBoxDelegate>

@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) BEMCheckBox *isCompletedCheckbox;

@end




@implementation CompletionTableViewCell

-(void)setChecked:(BOOL)checked
{
    self.isCompletedCheckbox.on = checked;
}

-(UIProgressView *)progressBar
{
    if (!_progressBar) _progressBar = [[UIProgressView alloc] init];
    return _progressBar;
}

-(UILabel *)title
{
    if (!_title) _title = [[UILabel alloc] init];
    return _title;
}

-(BEMCheckBox *)isCompletedCheckbox
{
    if (!_isCompletedCheckbox){
        _isCompletedCheckbox = [[BEMCheckBox alloc] init];
        _isCompletedCheckbox.delegate = self;
    }
    
    return _isCompletedCheckbox;
}

-(void)setProgressAsDecimalPercent:(float)progressAsDecimalPercent
{
    self.progressBar.progress = progressAsDecimalPercent;
    //[self.progressIndicator setProgress:progressAsDecimalPercent animated:YES];
    

}

-(void)setWeeklyProgress:(int)weeklyProgress
{
    if (weeklyProgress < 3) {
        self.progressBar.progressTintColor = [UIColor redColor];
    }
    else if (weeklyProgress < 7) {
        self.progressBar.progressTintColor = [UIColor yellowColor];
    }
    else {
        self.progressBar.progressTintColor = [UIColor greenColor];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupProgressBarAutoLayout];
    if (!self.disableCheckBox) {
        [self setupIsCompletedCheckBoxAutoLayout];
    }
    [self setupTitleAutoLayout];
    

}

-(void)setupTitleAutoLayout
{
    [self.contentView addSubview:self.title];
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!self.disableCheckBox) {
        [self.title.trailingAnchor constraintLessThanOrEqualToAnchor:
         self.isCompletedCheckbox.leadingAnchor].active = YES;
        
        [self.title.firstBaselineAnchor constraintEqualToAnchor:
         self.isCompletedCheckbox.lastBaselineAnchor].active = YES;
    }
    
    else {
        [self.title.bottomAnchor constraintEqualToAnchor:self.progressBar.topAnchor].active = YES;
        [self.title.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    }
    [self.title.leadingAnchor constraintEqualToAnchor:
     self.contentView.leadingAnchor constant:8].active = YES;
}

-(void)setupProgressBarAutoLayout
{
    [self.contentView addSubview:self.progressBar];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.progressBar.trailingAnchor constraintEqualToAnchor:
     self.contentView.trailingAnchor constant:-8].active = YES;
    
    [self.progressBar.leadingAnchor constraintEqualToAnchor:
     self.contentView.leadingAnchor constant:8].active = YES;
    
    [self.progressBar.heightAnchor constraintEqualToConstant:10].active = YES;
    
    [self.progressBar.bottomAnchor constraintEqualToAnchor:
     self.contentView.bottomAnchor].active = YES;
}

-(void)setupIsCompletedCheckBoxAutoLayout
{
    [self.contentView addSubview:self.isCompletedCheckbox];
    self.isCompletedCheckbox.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.isCompletedCheckbox.trailingAnchor constraintEqualToAnchor:
     self.progressBar.trailingAnchor constant:0].active = YES;
    
    [self.isCompletedCheckbox.topAnchor constraintEqualToAnchor:
     self.contentView.topAnchor constant:10].active = YES;
    
    [self.isCompletedCheckbox.bottomAnchor constraintLessThanOrEqualToAnchor:
     self.progressBar.topAnchor constant:-5].active = YES;
    
    [self.isCompletedCheckbox.widthAnchor constraintEqualToConstant:25].active = YES;
    [self.isCompletedCheckbox.heightAnchor constraintEqualToConstant:25].active = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox
{
    //Sends this message up the responder chain so the cdtvc can handle it
    UIResponder *responder = self;
    while (responder.nextResponder != nil){
        responder = responder.nextResponder;
        //If animation stops for a checkbox in the HabitCDTVC then execute method
        if ([responder isKindOfClass:[HabitCDTVC class]]) {
            HabitCDTVC *hcdtvc = (HabitCDTVC *)responder;
            [hcdtvc didTouchCheckBox:checkBox inCell:self];
            break;
        }
        //If animation stops for a checkbox in the GoalCDTVC then execute method
        else if ([responder isKindOfClass:[GoalCDTVC class]]) {
            GoalCDTVC *gcdtvc = (GoalCDTVC *)responder;
            [gcdtvc didTouchCheckBox:checkBox inCell:self];
            break;

        }
    }
}

@end
