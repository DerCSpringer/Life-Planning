//
//  ToDoTableViewCell.h
//  LifePlanner
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"

@interface ToDoTableViewCell : UITableViewCell

- (instancetype) initWithToDo:(ToDo *)todo;




@end

@protocol CellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;
@end