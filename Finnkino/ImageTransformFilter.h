//
//  ImageTransformFilter.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFilter.h" 

@interface ImageTransformFilter : ImageFilter
{
  @private
  CGAffineTransform transform_;
}

@property (nonatomic, assign) CGAffineTransform transform;

- (id) initWithImageComponent:(id <ImageComponent>)component 
                    transform:(CGAffineTransform)transform;
- (void) apply;

@end
