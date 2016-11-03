//
//  DeleteCell.m
//  LifePlanner
//
//  Created by Daniel on 7/15/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "DeleteCell.h"

@implementation DeleteCell

- (void)awakeFromNib {
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.text = @"DELETE";
    deleteLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:deleteLabel];
    deleteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [deleteLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [deleteLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
