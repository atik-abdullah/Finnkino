//
//  FinnkinoInnerTableCell.m
//  Finnkino
//
//  Created by Abdullah Atik on 1/21/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "FinnkinoInnerTableCell.h"

@implementation FinnkinoInnerTableCell
@synthesize newsImage;
@synthesize newstitleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.newsImage = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2)];
        self.newsImage.opaque = YES;
        
        [self.contentView addSubview:self.newsImage];
        
        self.newstitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.newsImage.frame.size.height * 0.632, self.newsImage.frame.size.width, self.newsImage.frame.size.height * 0.37)] ;
        self.newstitleLabel.opaque = YES;
        self.newstitleLabel.backgroundColor = [UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9];
        self.newstitleLabel.textColor = [UIColor whiteColor];
        self.newstitleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.newstitleLabel.numberOfLines = 2;
        [self.newsImage addSubview:self.newstitleLabel];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.newsImage.frame];
        self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        
        self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
