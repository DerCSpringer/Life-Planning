//
//  HelpViewController.m
//  LifePlanner
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UITextView *helpText;

@end

@implementation HelpViewController
// use http://htmleditor.in/index.html to convert rtf document to html

#define HELP_IN_HTML @"<html><head><title></title><style type=\"text/css\"></style></head><body><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">To Do:</p><ul><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Selecting the alert option alerts you once on the due date</li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">A floating event shows up everyday until you complete it.<ul><li style=\"margin: 0px;\">It only shows up on today&rsquo;s date</li><li style=\"margin: 0px;\">Floating events are orange</li></ul></li></ul><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Habits:</p><ul><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Circle checkbox allows you to check off the habit for today</li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">The bar color tells you how well you&rsquo;re currently doing with the habit for the past seven days<ul><li style=\"margin: 0px;\">less than three completed times makes it red</li><li style=\"margin: 0px;\">less than seven completed times makes it yellow</li></ul></li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Adding habit</li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Repititions is the number of times you need to complete the habit</li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Completion type<ul><li style=\"margin: 0px;\">Alert: alerts you daily on the specified time to update the habit</li><li style=\"margin: 0px;\">Auto: automatically completes the habit at the specified time(no alert)</li><li style=\"margin: 0px;\">Manual: you must manually update the habit each day(no alert)</li></ul></li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Is part of goal<ul><li style=\"margin: 0px;\">You can group habits under one goal.&nbsp; Create&nbsp; goal first then modify the habits to select a specific goal</li></ul></li></ul><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Goals:</p><ul><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Goals display the general progress for a number of habits<ul><li style=\"margin: 0px;\">The color of the cell shows average habit performance for the past seven days</li></ul></li></ul><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New'; min-height: 14px;\">&nbsp;</p><p style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Options:</p><ul><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Habit alerts allows you to turn on or off all the alerts for habits</li><li style=\"margin: 0px; font-size: 12px; font-family: 'Courier New';\">Alert behavior<ul><li style=\"margin: 0px;\">You can selected when you will be alerted for a habit</li><li style=\"margin: 0px;\">If red is selected then you will be alerted for a habit when it&rsquo;s been completed less then three times in the past seven days</li><li style=\"margin: 0px;\">If red/yellow is selected then you will be alerted for a habit when it&rsquo;s been completed less then seven times in the past seven days<ul><li style=\"margin: 0px;\">Either alert is fired at the time you selected inside each habit</li></ul></li><li style=\"margin: 0px;\">Alert behavior only affects habits which have the auto/manual option selected<ul><li style=\"margin: 0px;\">If alert option is selected then it will always alert</li></ul></li></ul></li></ul></body></html>"

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlString = HELP_IN_HTML;
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.helpText.attributedText = attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
