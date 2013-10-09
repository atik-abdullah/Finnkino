//
//  ImageFilter.m
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import "ImageFilter.h"


@implementation ImageFilter

- (id) initWithImageComponent:(id <ImageComponent>) component
{
  if (self = [super init])
  {
    // save an ImageComponent
    [self setComponent:component];
  }
  
  return self;
}

- (void) apply
{
  // should be overridden by subclasses
  // to apply real filters
}


- (void) drawAsPatternInRect:(CGRect)rect
{
  [self apply];
  [self.component drawAsPatternInRect:rect];
}

- (void) drawAtPoint:(CGPoint)point
{
  [self apply];
  [self.component drawAtPoint:point];
}

- (void) drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
  [self apply];
  [self.component drawAtPoint:point
                blendMode:blendMode
                    alpha:alpha];
}

- (void) drawInRect:(CGRect)rect
{
  [self apply];
  [self.component drawInRect:rect];
}

- (void) drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
  [self apply];
  [self.component drawInRect:rect
               blendMode:blendMode
                   alpha:alpha];
}




@end
