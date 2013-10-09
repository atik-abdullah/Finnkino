//
//  ImageShadowFilter.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "ImageShadowFilter.h"


@implementation ImageShadowFilter

- (void) apply
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // set up shadow
  CGSize offset = CGSizeMake (-25,  15);
  CGContextSetShadow(context, offset, 20.0);
}

@end
