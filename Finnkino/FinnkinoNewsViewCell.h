//
//  FinnkinoNewsViewCell.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength                                320
// Padding for the title label in an article's cell
#define kArticleTitleLabelPadding                   4
// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding                         0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding                       0
// The background color of the vertical table view
#define kVerticalTableBackgroundColor               [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.58823529 alpha:1.0]

@interface FinnkinoNewsViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableViewForOtherTableViewsCell;
@property (nonatomic, retain) NSMutableArray *articles;

@end
