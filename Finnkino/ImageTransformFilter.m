//
//  ImageTransformFilter.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "ImageTransformFilter.h"

@implementation ImageTransformFilter

@synthesize transform=transform_;


- (id) initWithImageComponent:(id <ImageComponent>)component 
                    transform:(CGAffineTransform)transform
{
  if (self = [super initWithImageComponent:component])
  {
    [self setTransform:transform];
  }
  
  return self;
}

- (void) apply
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // setup transformation
  CGContextConcatCTM(context, transform_);
}

@end
