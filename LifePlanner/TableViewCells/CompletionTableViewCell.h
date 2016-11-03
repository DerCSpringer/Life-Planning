//
//  HabitTableViewCell.h
//  LifePlanner
//
//  Created by Daniel on 5/25/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface CompletionTableViewCell : UITableViewCell

@property (nonatomic) float progressAsDecimalPercent;
@property (strong, nonatomic) UILabel *title;
@property (nonatomic) BOOL checked;
@property (nonatomic) int weeklyProgress;
@property (nonatomic) BOOL disableCheckBox;


@end
