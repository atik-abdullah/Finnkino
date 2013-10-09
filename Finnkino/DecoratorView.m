//
//  DecoratorView.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "DecoratorView.h"


@implementation DecoratorView

@synthesize image=image_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
      [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
  // Drawing code.
  [image_ drawInRect:rect];
}

@end
