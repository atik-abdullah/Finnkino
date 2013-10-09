//
//  DecoratorView.h
//  Finnkino
//
//  Created by Abdullah Atik on 10/7/13.
//  Copyright (c) 2013 Abdullah Atik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DecoratorView : UIView 
{
  @private
  UIImage *image_;
}

@property (nonatomic, retain) UIImage *image;

@end
