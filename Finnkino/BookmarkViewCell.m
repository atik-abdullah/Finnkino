//
//  BookmarkViewCell.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/17/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "BookmarkViewCell.h"

@implementation BookmarkViewCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    [imageView setImage:image];
}

@end
