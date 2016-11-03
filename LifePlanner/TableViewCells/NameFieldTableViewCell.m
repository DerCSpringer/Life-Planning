//
//  NameFieldTableViewCell.m
//  LifePlanner
//
//  Created by Daniel on 6/9/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "NameFieldTableViewCell.h"

@interface NameFieldTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;

@end

@implementation NameFieldTableViewCell


@synthesize title = _title;

-(NSString *)title
{
    if (!_title) _title = [[NSString alloc] init];
    _title = self.nameField.text;
    return _title;
}

-(void)setTitle:(NSString *)title
{
    self.nameField.text = title;
}

-(UITextField *)nameField
{
    if(!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _nameField.enabled = YES;
        _nameField.adjustsFontSizeToFitWidth = YES;
        _nameField.placeholder = @"Title";
    }
    return _nameField;
    
}

-(void)awakeFromNib
{
    [self.contentView addSubview:self.nameField];
    self.nameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.nameField.delegate = self;
    [self textInputContraints];

}

- (void)textInputContraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // make "return key" hide keyboard
    return YES;
}


@end
