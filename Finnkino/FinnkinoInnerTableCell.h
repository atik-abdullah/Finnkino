//
//  FinnkinoInnerTableCell.h
//  Finnkino
//
//  Created by Abdullah Atik on 1/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>
// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define kHorizontalTableBackgroundColor             [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]
// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          3
// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth                                  106
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight                                 106

// The background color on the horizontal table view for when we select a particular cell
#define kHorizontalTableSelectedBackgroundColor     [UIColor colorWithRed:0.0 green:0.59607843 blue:0.37254902 alpha:1.0]

@interface FinnkinoInnerTableCell : UITableViewCell
@property (nonatomic, strong) UIImageView *newsImage;
@property (nonatomic, strong) UILabel *newstitleLabel;

@end
