//
//  ImageFilter.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageComponent.h"
#import "UIImage+ImageComponent.h"

@interface ImageFilter : NSObject <ImageComponent>

@property (nonatomic, retain) id <ImageComponent> component;

- (void) apply;
- (id) initWithImageComponent:(id <ImageComponent>) component;

// overridden methods in UIImage APIs
- (void) drawAsPatternInRect:(CGRect)rect; 
- (void) drawAtPoint:(CGPoint)point;
- (void) drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void) drawInRect:(CGRect)rect;
- (void) drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;


@end
